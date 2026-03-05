import 'package:test/test.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart';


/// tests for CompanyApi
void main() {
  final instance = NexusSkladOpenapiClient().getCompanyApi();

  group(CompanyApi, () {
    // Get company
    //
    //Future<CompanyResponse> v1CompanyGet() async
    test('test v1CompanyGet', () async {
      // TODO
    });

    // Update company
    //
    //Future<CompanyUpdateResponse> v1CompanyPatch(UpdateCompanyRequest updateCompanyRequest) async
    test('test v1CompanyPatch', () async {
      // TODO
    });

  });
}
