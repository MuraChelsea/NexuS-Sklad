import 'package:test/test.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart';


/// tests for AuditApi
void main() {
  final instance = NexusSkladOpenapiClient().getAuditApi();

  group(AuditApi, () {
    // List audit logs
    //
    //Future<AuditListResponse> v1AuditGet({ String userId, String entityType, String action, int limit }) async
    test('test v1AuditGet', () async {
      // TODO
    });

  });
}
