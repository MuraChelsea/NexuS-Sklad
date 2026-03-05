import 'package:flutter/foundation.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart' as generated;

import '../../../core/network/api_contract.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/offline_sync_issue.dart';
import '../../../core/network/transport_mapper.dart';
import '../../../core/storage/cache_keys.dart';
import '../../../core/storage/local_cache_store.dart';
import 'company_queue_store.dart';

class CompanyRepository {
  CompanyRepository(
    this._apiClient, {
    LocalCacheStore? cacheStore,
    CompanyQueueStore? queueStore,
  })  : _cacheStore = cacheStore ?? LocalCacheStore.instance,
        _queueStore =
            queueStore ?? CompanyQueueStore(cacheStore: cacheStore ?? LocalCacheStore.instance);

  final ApiClient _apiClient;
  final LocalCacheStore _cacheStore;
  final CompanyQueueStore _queueStore;

  Future<MobileCompany> fetchCompany({
    required String accessToken,
  }) async {
    try {
      final json = await _apiClient.get(
        '/v1/company',
        accessToken: accessToken,
      );
      await _cacheStore.writeJson(CacheKeys.companyCurrent, json);
      return _decodeCompany(json);
    } catch (_) {
      final cached = await _cacheStore.readJson(CacheKeys.companyCurrent);
      if (cached != null) {
        return _decodeCompany(cached);
      }
      rethrow;
    }
  }

  Future<CompanyWriteResult> updateCompany({
    required String accessToken,
    required MobileCompany fallbackCompany,
    String? name,
    String? city,
    String? phone,
  }) async {
    try {
      final json = await _apiClient.patch(
        '/v1/company',
        accessToken: accessToken,
        body: generated.UpdateCompanyRequest(
          name: name,
          city: city,
          phone: phone,
        ).toJson(),
      );

      await _cacheStore.writeJson(CacheKeys.companyCurrent, {
        'module': 'company',
        'item': json['item'],
      });

      return CompanyWriteResult(
        queued: false,
        company: _decodeCompany(json, action: 'update'),
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }

      await _queueStore.write(
        PendingCompanyUpdate(
          name: name,
          city: city,
          phone: phone,
          createdAt: DateTime.now(),
        ),
      );

      final updated = fallbackCompany.copyWith(
        name: name,
        city: city,
        phone: phone,
      );
      await _cacheStore.writeJson(CacheKeys.companyCurrent, {
        'module': 'company',
        'item': updated.toJson(),
      });

      return CompanyWriteResult(
        queued: true,
        company: updated,
      );
    }
  }

  Future<CompanySyncResult> flushPendingUpdate({
    required String accessToken,
  }) async {
    final pending = await _queueStore.read();
    if (pending == null) {
      return const CompanySyncResult(
        applied: false,
        hasPending: false,
      );
    }

    try {
      final json = await _apiClient.patch(
        '/v1/company',
        accessToken: accessToken,
        body: generated.UpdateCompanyRequest(
          name: pending.name,
          city: pending.city,
          phone: pending.phone,
        ).toJson(),
      );
      await _cacheStore.writeJson(CacheKeys.companyCurrent, {
        'module': 'company',
        'item': json['item'],
      });
      await _queueStore.clear();
      return CompanySyncResult(
        applied: true,
        hasPending: false,
        company: _decodeCompany(json, action: 'update'),
      );
    } on ApiException catch (error) {
      final issue = OfflineSyncIssue.fromApiException(error);
      return CompanySyncResult(
        applied: false,
        hasPending: true,
        blockingMessage: issue.message,
        hasConflict: issue.isConflict,
      );
    } catch (error) {
      if (!isOfflineQueueableError(error)) {
        rethrow;
      }
      return const CompanySyncResult(
        applied: false,
        hasPending: true,
      );
    }
  }

  Future<bool> hasPendingUpdate() async {
    return await _queueStore.read() != null;
  }

  Future<void> discardPendingUpdate() {
    return _queueStore.clear();
  }
}

MobileCompany _decodeCompany(
  Map<String, dynamic> json, {
  String? action,
}) {
  return ApiContract.item(
    json,
    module: 'company',
    action: action,
    decode: (payload) => mapTransport(
      payload,
      decodeTransport: generated.Company.fromJson,
      toDomain: MobileCompany.fromTransport,
    ),
  );
}

@immutable
class CompanyWriteResult {
  const CompanyWriteResult({
    required this.queued,
    required this.company,
  });

  final bool queued;
  final MobileCompany company;
}

@immutable
class CompanySyncResult {
  const CompanySyncResult({
    required this.applied,
    required this.hasPending,
    this.company,
    this.blockingMessage,
    this.hasConflict = false,
  });

  final bool applied;
  final bool hasPending;
  final MobileCompany? company;
  final String? blockingMessage;
  final bool hasConflict;
}

class MobileCompany {
  const MobileCompany({
    required this.id,
    required this.name,
    required this.city,
    required this.phone,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String? city;
  final String? phone;
  final DateTime createdAt;

  factory MobileCompany.fromTransport(generated.Company transport) {
    return MobileCompany(
      id: transport.id,
      name: transport.name,
      city: transport.city,
      phone: transport.phone,
      createdAt: transport.createdAt,
    );
  }

  MobileCompany copyWith({
    String? name,
    String? city,
    String? phone,
  }) {
    return MobileCompany(
      id: id,
      name: name ?? this.name,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
