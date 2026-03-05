import 'package:flutter/foundation.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart' as generated;

import '../../../core/network/api_contract.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/offline_sync_issue.dart';
import '../../../core/network/transport_mapper.dart';
import '../../../core/storage/cache_keys.dart';
import '../../../core/storage/local_cache_store.dart';
import 'user_queue_store.dart';

class UserRepository {
  UserRepository(
    this._apiClient, {
    LocalCacheStore? cacheStore,
    UserQueueStore? queueStore,
  })  : _cacheStore = cacheStore ?? LocalCacheStore.instance,
        _queueStore = queueStore ?? UserQueueStore(cacheStore: cacheStore ?? LocalCacheStore.instance);

  final ApiClient _apiClient;
  final LocalCacheStore _cacheStore;
  final UserQueueStore _queueStore;

  Future<List<MobileTeamUser>> fetchUsers({
    required String accessToken,
  }) async {
    try {
      final json = await _apiClient.get(
        '/v1/users',
        accessToken: accessToken,
      );
      await _cacheStore.writeJson(CacheKeys.usersList, json);
      return _applyPendingUpdates(_decodeUserList(json), await _queueStore.readAll());
    } catch (_) {
      final cached = await _cacheStore.readJson(CacheKeys.usersList);
      if (cached != null) {
        return _applyPendingUpdates(_decodeUserList(cached), await _queueStore.readAll());
      }
      rethrow;
    }
  }

  Future<InviteUserResult> inviteUser({
    required String accessToken,
    required String email,
    required String role,
  }) async {
    try {
      final json = await _apiClient.post(
        '/v1/users/invite',
        accessToken: accessToken,
        body: generated.InviteUserRequest(
          email: email,
          role: _inviteUserRoleTransport(role),
        ).toJson(),
      );

      return ApiContract.invite(
        json,
        decode: (payload) => mapTransport(
          payload,
          decodeTransport: generated.InviteUserResponse.fromJson,
          toDomain: InviteUserResult.fromTransport,
        ),
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }

      await _queueStore.enqueueInvite(
        PendingUserInvite(
          localId: 'local:${DateTime.now().microsecondsSinceEpoch}',
          email: email,
          role: role,
          createdAt: DateTime.now(),
        ),
      );

      return InviteUserResult.queued(
        email: email,
        role: role,
      );
    }
  }

  Future<UserWriteResult> updateUser({
    required String accessToken,
    required MobileTeamUser fallbackUser,
    required String userId,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? role,
    bool? isActive,
  }) async {
    try {
      final json = await _apiClient.patch(
        '/v1/users/$userId',
        accessToken: accessToken,
        body: generated.UpdateUserRequest(
          name: name,
          email: email,
          phone: phone,
          password: password,
          role: role == null ? null : _updateUserRoleTransport(role),
          isActive: isActive,
        ).toJson(),
      );

      return UserWriteResult(
        queued: false,
        user: ApiContract.item(
          json,
          module: 'users',
          action: 'update',
          decode: (payload) => mapTransport(
            payload,
            decodeTransport: generated.CompanyUser.fromJson,
            toDomain: MobileTeamUser.fromTransport,
          ),
        ),
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }

      await _queueStore.enqueue(
        PendingUserUpdate(
          userId: userId,
          name: name,
          email: email,
          phone: phone,
          password: password,
          role: role,
          isActive: isActive,
          createdAt: DateTime.now(),
        ),
      );

      return UserWriteResult(
        queued: true,
        user: fallbackUser.copyWith(
          name: name,
          email: email,
          phone: phone,
          role: role,
          isActive: isActive,
        ),
      );
    }
  }

  Future<int> getPendingUpdateCount() async {
    final items = await _queueStore.readAll();
    return items.length;
  }

  Future<List<PendingUserUpdateView>> getPendingUpdates() async {
    final items = await _queueStore.readAll();
    return items
        .map(
          (item) => PendingUserUpdateView(
            userId: item.userId,
            name: item.name ?? 'Без имени',
            role: item.role,
            createdAt: item.createdAt,
          ),
        )
        .toList(growable: false);
  }

  Future<void> clearPendingUpdates() {
    return _queueStore.writeAll(const []);
  }

  Future<void> discardPendingUpdate(String userId) async {
    final items = await _queueStore.readAll();
    await _queueStore.writeAll(
      items.where((item) => item.userId != userId).toList(growable: false),
    );
  }

  Future<String?> retryPendingUpdate({
    required String accessToken,
    required String userId,
  }) async {
    final items = await _queueStore.readAll();
    final pending = items.where((item) => item.userId == userId).toList(growable: false);
    if (pending.isEmpty) {
      return null;
    }

    final item = pending.first;
    try {
      await _sendPendingUpdate(
        accessToken: accessToken,
        item: item,
      );
      await discardPendingUpdate(userId);
      return null;
    } on ApiException catch (error) {
      return OfflineSyncIssue.fromApiException(error).message;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }
      return 'Нет соединения. Повторим позже.';
    }
  }

  Future<Set<String>> getPendingUpdateIds() async {
    final items = await _queueStore.readAll();
    return items.map((item) => item.userId).toSet();
  }

  Future<List<PendingUserInviteView>> getPendingInvites() async {
    final items = await _queueStore.readPendingInvites();
    return items
        .map(
          (item) => PendingUserInviteView(
            localId: item.localId,
            email: item.email,
            role: item.role,
            createdAt: item.createdAt,
          ),
        )
        .toList(growable: false);
  }

  Future<int> getPendingInviteCount() async {
    final items = await _queueStore.readPendingInvites();
    return items.length;
  }

  Future<void> clearPendingInvites() {
    return _queueStore.writePendingInvites(const []);
  }

  Future<void> discardPendingInvite(String localId) async {
    final items = await _queueStore.readPendingInvites();
    await _queueStore.writePendingInvites(
      items.where((item) => item.localId != localId).toList(growable: false),
    );
  }

  Future<String?> retryPendingInvite({
    required String accessToken,
    required String localId,
  }) async {
    final items = await _queueStore.readPendingInvites();
    final pending = items.where((item) => item.localId == localId).toList(growable: false);
    if (pending.isEmpty) {
      return null;
    }

    final item = pending.first;
    try {
      await _sendPendingInvite(
        accessToken: accessToken,
        item: item,
      );
      await discardPendingInvite(localId);
      return null;
    } on ApiException catch (error) {
      return OfflineSyncIssue.fromApiException(error).message;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }
      return 'Нет соединения. Повторим позже.';
    }
  }

  Future<UserSyncResult> flushPendingUpdates({
    required String accessToken,
  }) async {
    final inviteItems = await _queueStore.readPendingInvites();
    final items = await _queueStore.readAll();
    if (items.isEmpty && inviteItems.isEmpty) {
      return const UserSyncResult(
        appliedCount: 0,
        pendingCount: 0,
      );
    }

    final remainingInvites = <PendingUserInvite>[];
    final remaining = <PendingUserUpdate>[];
    var appliedCount = 0;
    var conflictCount = 0;
    String? blockingMessage;
    var stop = false;

    for (final item in inviteItems) {
      if (stop) {
        remainingInvites.add(item);
        continue;
      }

      try {
        await _sendPendingInvite(accessToken: accessToken, item: item);
        appliedCount += 1;
      } on ApiException catch (error) {
        final issue = OfflineSyncIssue.fromApiException(error);
        remainingInvites.add(item);
        blockingMessage ??= issue.message;
        if (issue.isConflict) {
          conflictCount += 1;
          continue;
        }
        stop = true;
      } catch (error) {
        if (!isOfflineQueueableError(error)) {
          rethrow;
        }
        remainingInvites.add(item);
        stop = true;
      }
    }

    for (final item in items) {
      if (stop) {
        remaining.add(item);
        continue;
      }

      try {
        await _sendPendingUpdate(accessToken: accessToken, item: item);
        appliedCount += 1;
      } on ApiException catch (error) {
        final issue = OfflineSyncIssue.fromApiException(error);
        remaining.add(item);
        blockingMessage ??= issue.message;
        if (issue.isConflict) {
          conflictCount += 1;
          continue;
        }
        stop = true;
      } catch (error) {
        if (!isOfflineQueueableError(error)) {
          rethrow;
        }
        remaining.add(item);
        stop = true;
      }
    }

    await _queueStore.writePendingInvites(remainingInvites);
    await _queueStore.writeAll(remaining);

    return UserSyncResult(
      appliedCount: appliedCount,
      pendingCount: remainingInvites.length + remaining.length,
      blockingMessage: blockingMessage,
      conflictCount: conflictCount,
    );
  }

  List<MobileTeamUser> _applyPendingUpdates(
    List<MobileTeamUser> users,
    List<PendingUserUpdate> pending,
  ) {
    if (pending.isEmpty) {
      return users;
    }

    final byId = {for (final item in pending) item.userId: item};
    return users.map((user) {
      final queued = byId[user.id];
      if (queued == null) {
        return user;
      }
      return user.copyWith(
        name: queued.name,
        email: queued.email,
        phone: queued.phone,
        role: queued.role,
        isActive: queued.isActive,
      );
    }).toList(growable: false);
  }

  Future<void> _sendPendingUpdate({
    required String accessToken,
    required PendingUserUpdate item,
  }) {
    return _apiClient.patch(
      '/v1/users/${item.userId}',
      accessToken: accessToken,
      body: generated.UpdateUserRequest(
        name: item.name,
        email: item.email,
        phone: item.phone,
        password: item.password,
        role: item.role == null ? null : _updateUserRoleTransport(item.role!),
        isActive: item.isActive,
      ).toJson(),
    );
  }

  Future<void> _sendPendingInvite({
    required String accessToken,
    required PendingUserInvite item,
  }) {
    return _apiClient.post(
      '/v1/users/invite',
      accessToken: accessToken,
      body: generated.InviteUserRequest(
        email: item.email,
        role: _inviteUserRoleTransport(item.role),
      ).toJson(),
    );
  }
}

List<MobileTeamUser> _decodeUserList(Map<String, dynamic> json) {
  return ApiContract.list(
    json,
    module: 'users',
    decode: (payload) => mapTransport(
      payload,
      decodeTransport: generated.CompanyUser.fromJson,
      toDomain: MobileTeamUser.fromTransport,
    ),
  );
}

generated.InviteUserRequestRoleEnum _inviteUserRoleTransport(String role) {
  switch (role) {
    case 'MANAGER':
      return generated.InviteUserRequestRoleEnum.MANAGER;
    case 'STAFF':
      return generated.InviteUserRequestRoleEnum.STAFF;
    default:
      throw ArgumentError.value(role, 'role', 'Unsupported invite role');
  }
}

generated.UpdateUserRequestRoleEnum _updateUserRoleTransport(String role) {
  switch (role) {
    case 'MANAGER':
      return generated.UpdateUserRequestRoleEnum.MANAGER;
    case 'STAFF':
      return generated.UpdateUserRequestRoleEnum.STAFF;
    default:
      throw ArgumentError.value(role, 'role', 'Unsupported user role');
  }
}

@immutable
class UserWriteResult {
  const UserWriteResult({
    required this.queued,
    required this.user,
  });

  final bool queued;
  final MobileTeamUser user;
}

@immutable
class UserSyncResult {
  const UserSyncResult({
    required this.appliedCount,
    required this.pendingCount,
    this.blockingMessage,
    this.conflictCount = 0,
  });

  final int appliedCount;
  final int pendingCount;
  final String? blockingMessage;
  final int conflictCount;

  bool get hasConflict => conflictCount > 0;
}

@immutable
class PendingUserUpdateView {
  const PendingUserUpdateView({
    required this.userId,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  final String userId;
  final String name;
  final String? role;
  final DateTime createdAt;
}

@immutable
class PendingUserInviteView {
  const PendingUserInviteView({
    required this.localId,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  final String localId;
  final String email;
  final String role;
  final DateTime createdAt;
}

class MobileTeamUser {
  const MobileTeamUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.inviteExpiresAt,
  });

  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? inviteExpiresAt;

  bool get isPendingInvite => !isActive && inviteExpiresAt != null;

  factory MobileTeamUser.fromTransport(generated.CompanyUser transport) {
    return MobileTeamUser(
      id: transport.id,
      email: transport.email ?? '',
      name: transport.name,
      phone: transport.phone,
      role: transport.role.value,
      isActive: transport.isActive,
      createdAt: transport.createdAt,
      inviteExpiresAt: transport.inviteExpiresAt,
    );
  }

  MobileTeamUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    bool? isActive,
  }) {
    return MobileTeamUser(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      inviteExpiresAt: inviteExpiresAt,
    );
  }
}

class InviteUserResult {
  const InviteUserResult({
    required this.user,
    required this.inviteToken,
  });

  final MobileTeamUser user;
  final String inviteToken;
  bool get queued => inviteToken.isEmpty;

  factory InviteUserResult.fromTransport(generated.InviteUserResponse transport) {
    return InviteUserResult(
      user: MobileTeamUser.fromTransport(transport.user),
      inviteToken: transport.inviteToken,
    );
  }

  factory InviteUserResult.queued({
    required String email,
    required String role,
  }) {
    return InviteUserResult(
      user: MobileTeamUser(
        id: 'local:${DateTime.now().microsecondsSinceEpoch}',
        name: email,
        email: email,
        phone: null,
        role: role,
        isActive: false,
        createdAt: DateTime.now(),
        inviteExpiresAt: null,
      ),
      inviteToken: '',
    );
  }
}
