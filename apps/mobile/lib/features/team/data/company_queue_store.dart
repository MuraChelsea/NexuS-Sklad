import '../../../core/network/json_reader.dart';
import '../../../core/storage/local_cache_store.dart';

const _companyQueueKey = 'company.pending.update';

class CompanyQueueStore {
  CompanyQueueStore({
    LocalCacheStore? cacheStore,
  }) : _cacheStore = cacheStore ?? LocalCacheStore.instance;

  final LocalCacheStore _cacheStore;

  Future<PendingCompanyUpdate?> read() async {
    final json = await _cacheStore.readJson(_companyQueueKey);
    if (json == null) {
      return null;
    }
    return PendingCompanyUpdate.fromJson(json);
  }

  Future<void> write(PendingCompanyUpdate item) {
    return _cacheStore.writeJson(_companyQueueKey, item.toJson());
  }

  Future<void> clear() {
    return _cacheStore.remove(_companyQueueKey);
  }
}

class PendingCompanyUpdate {
  const PendingCompanyUpdate({
    required this.name,
    required this.city,
    required this.phone,
    required this.createdAt,
  });

  final String? name;
  final String? city;
  final String? phone;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingCompanyUpdate.fromJson(Map<String, dynamic> json) {
    return PendingCompanyUpdate(
      name: JsonReader.nullableString(json, 'name'),
      city: JsonReader.nullableString(json, 'city'),
      phone: JsonReader.nullableString(json, 'phone'),
      createdAt: JsonReader.dateTime(json, 'createdAt'),
    );
  }
}
