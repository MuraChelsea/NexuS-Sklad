import '../../../core/network/json_reader.dart';
import '../../../core/storage/local_cache_store.dart';

const _userQueueKey = 'users.pending.update.queue';
const _userInviteQueueKey = 'users.pending.invite.queue';

class UserQueueStore {
  UserQueueStore({
    LocalCacheStore? cacheStore,
  }) : _cacheStore = cacheStore ?? LocalCacheStore.instance;

  final LocalCacheStore _cacheStore;

  Future<List<PendingUserUpdate>> readAll() async {
    final json = await _cacheStore.readJson(_userQueueKey);
    if (json == null) {
      return const [];
    }

    return JsonReader.objectList(json, 'items')
        .map(PendingUserUpdate.fromJson)
        .toList(growable: false);
  }

  Future<List<PendingUserInvite>> readPendingInvites() async {
    final json = await _cacheStore.readJson(_userInviteQueueKey);
    if (json == null) {
      return const [];
    }

    return JsonReader.objectList(json, 'items')
        .map(PendingUserInvite.fromJson)
        .toList(growable: false);
  }

  Future<void> writeAll(List<PendingUserUpdate> items) {
    return _cacheStore.writeJson(
      _userQueueKey,
      {
        'items': items.map((item) => item.toJson()).toList(growable: false),
      },
    );
  }

  Future<void> writePendingInvites(List<PendingUserInvite> items) {
    return _cacheStore.writeJson(
      _userInviteQueueKey,
      {
        'items': items.map((item) => item.toJson()).toList(growable: false),
      },
    );
  }

  Future<void> enqueue(PendingUserUpdate item) async {
    final items = await readAll();
    final filtered = items.where((entry) => entry.userId != item.userId).toList(growable: false);
    await writeAll([...filtered, item]);
  }

  Future<void> enqueueInvite(PendingUserInvite item) async {
    final items = await readPendingInvites();
    await writePendingInvites([...items, item]);
  }
}

class PendingUserUpdate {
  const PendingUserUpdate({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  final String userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? password;
  final String? role;
  final bool? isActive;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingUserUpdate.fromJson(Map<String, dynamic> json) {
    return PendingUserUpdate(
      userId: JsonReader.string(json, 'userId'),
      name: JsonReader.nullableString(json, 'name'),
      email: JsonReader.nullableString(json, 'email'),
      phone: JsonReader.nullableString(json, 'phone'),
      password: JsonReader.nullableString(json, 'password'),
      role: JsonReader.nullableString(json, 'role'),
      isActive: json['isActive'] is bool ? json['isActive'] as bool : null,
      createdAt: JsonReader.dateTime(json, 'createdAt'),
    );
  }
}

class PendingUserInvite {
  const PendingUserInvite({
    required this.localId,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  final String localId;
  final String email;
  final String role;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'email': email,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingUserInvite.fromJson(Map<String, dynamic> json) {
    return PendingUserInvite(
      localId: JsonReader.string(json, 'localId'),
      email: JsonReader.string(json, 'email'),
      role: JsonReader.string(json, 'role'),
      createdAt: JsonReader.dateTime(json, 'createdAt'),
    );
  }
}
