import 'package:test/test.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart';


/// tests for CategoriesApi
void main() {
  final instance = NexusSkladOpenapiClient().getCategoriesApi();

  group(CategoriesApi, () {
    // Get category
    //
    //Future<CategoryResponse> v1CategoriesCategoryIdGet(String categoryId) async
    test('test v1CategoriesCategoryIdGet', () async {
      // TODO
    });

    // Update category
    //
    //Future<CategoryUpdateResponse> v1CategoriesCategoryIdPatch(String categoryId, UpdateCategoryRequest updateCategoryRequest) async
    test('test v1CategoriesCategoryIdPatch', () async {
      // TODO
    });

    // List categories
    //
    //Future<CategoryListResponse> v1CategoriesGet() async
    test('test v1CategoriesGet', () async {
      // TODO
    });

    // Create category
    //
    //Future<CategoryResponse> v1CategoriesPost(CreateCategoryRequest createCategoryRequest) async
    test('test v1CategoriesPost', () async {
      // TODO
    });

  });
}
