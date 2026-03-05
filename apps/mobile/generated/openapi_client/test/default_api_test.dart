import 'package:test/test.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart';


/// tests for DefaultApi
void main() {
  final instance = NexusSkladOpenapiClient().getDefaultApi();

  group(DefaultApi, () {
    // Health check
    //
    //Future healthGet() async
    test('test healthGet', () async {
      // TODO
    });

  });
}
