import '../../../core/network/api_contract.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/json_reader.dart';
import '../../../core/storage/cache_keys.dart';
import '../../../core/storage/local_cache_store.dart';

class DashboardRepository {
  DashboardRepository(
    this._apiClient, {
    LocalCacheStore? cacheStore,
  }) : _cacheStore = cacheStore ?? LocalCacheStore.instance;

  final ApiClient _apiClient;
  final LocalCacheStore _cacheStore;

  Future<DashboardSummary> fetchDaily({
    required String accessToken,
  }) async {
    try {
      final json = await _apiClient.get(
        '/v1/reports/daily',
        accessToken: accessToken,
      );
      await _cacheStore.writeJson(CacheKeys.dashboardDaily, json);
      return _decode(json);
    } catch (_) {
      final cached = await _cacheStore.readJson(CacheKeys.dashboardDaily);
      if (cached != null) {
        return _decode(cached);
      }
      rethrow;
    }
  }

  DashboardSummary _decode(JsonMap json) {
    return ApiContract.report(
      json,
      report: 'daily',
      decode: DashboardSummary.fromJson,
    );
  }
}

class DashboardSummary {
  const DashboardSummary({
    required this.date,
    required this.lowStockCount,
    required this.totalMovementCount,
    required this.inventorySessionsCount,
    required this.incomeCount,
    required this.expenseCount,
    required this.adjustmentCount,
    required this.inventoryDiffCount,
  });

  final String date;
  final int lowStockCount;
  final int totalMovementCount;
  final int inventorySessionsCount;
  final int incomeCount;
  final int expenseCount;
  final int adjustmentCount;
  final int inventoryDiffCount;

  factory DashboardSummary.fromJson(JsonMap json) {
    final movementSummary = JsonReader.object(json, 'movementSummary');
    final inventory = JsonReader.object(json, 'inventory');
    final stock = JsonReader.object(json, 'stock');

    int readMovementCount(String key) {
      final item = JsonReader.nullableObject(movementSummary, key);
      if (item == null) {
        return 0;
      }
      return JsonReader.integer(item, 'count');
    }

    final incomeCount = readMovementCount('INCOME');
    final expenseCount = readMovementCount('EXPENSE');
    final adjustmentCount = readMovementCount('ADJUSTMENT');
    final inventoryDiffCount = readMovementCount('INVENTORY_DIFF');

    return DashboardSummary(
      date: JsonReader.string(json, 'date'),
      lowStockCount: JsonReader.integer(stock, 'lowStockCount'),
      totalMovementCount:
          incomeCount + expenseCount + adjustmentCount + inventoryDiffCount,
      inventorySessionsCount: JsonReader.integer(inventory, 'sessionsCount'),
      incomeCount: incomeCount,
      expenseCount: expenseCount,
      adjustmentCount: adjustmentCount,
      inventoryDiffCount: inventoryDiffCount,
    );
  }
}
