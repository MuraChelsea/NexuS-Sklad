import 'package:test/test.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart';


/// tests for ReportsApi
void main() {
  final instance = NexusSkladOpenapiClient().getReportsApi();

  group(ReportsApi, () {
    // Daily report
    //
    //Future<DailyReportResponse> v1ReportsDailyGet({ DateTime date }) async
    test('test v1ReportsDailyGet', () async {
      // TODO
    });

    // Stock report
    //
    //Future<StockReportResponse> v1ReportsStockGet({ String categoryId, String search, bool lowOnly, int limit }) async
    test('test v1ReportsStockGet', () async {
      // TODO
    });

  });
}
