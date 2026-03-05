import 'package:test/test.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart';


/// tests for ProductsApi
void main() {
  final instance = NexusSkladOpenapiClient().getProductsApi();

  group(ProductsApi, () {
    // List products
    //
    //Future<ProductListResponse> v1ProductsGet({ String search, String categoryId }) async
    test('test v1ProductsGet', () async {
      // TODO
    });

    // Create product
    //
    //Future<ProductResponse> v1ProductsPost(CreateProductRequest createProductRequest) async
    test('test v1ProductsPost', () async {
      // TODO
    });

    // Get product
    //
    //Future<ProductResponse> v1ProductsProductIdGet(String productId) async
    test('test v1ProductsProductIdGet', () async {
      // TODO
    });

    // Update product
    //
    //Future<ProductUpdateResponse> v1ProductsProductIdPatch(String productId, UpdateProductRequest updateProductRequest) async
    test('test v1ProductsProductIdPatch', () async {
      // TODO
    });

  });
}
