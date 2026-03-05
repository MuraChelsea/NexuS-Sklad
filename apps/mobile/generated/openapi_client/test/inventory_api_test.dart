import 'package:test/test.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart';


/// tests for InventoryApi
void main() {
  final instance = NexusSkladOpenapiClient().getInventoryApi();

  group(InventoryApi, () {
    // Finish inventory session
    //
    //Future<InventoryFinishResponse> v1InventoryInventoryIdFinishPost(String inventoryId, FinishInventoryRequest finishInventoryRequest) async
    test('test v1InventoryInventoryIdFinishPost', () async {
      // TODO
    });

    // Get inventory session
    //
    //Future<InventoryResponse> v1InventoryInventoryIdGet(String inventoryId) async
    test('test v1InventoryInventoryIdGet', () async {
      // TODO
    });

    // Update inventory item
    //
    //Future<InventoryItemResponse> v1InventoryInventoryIdItemsItemIdPatch(String inventoryId, String itemId, UpdateInventoryItemRequest updateInventoryItemRequest) async
    test('test v1InventoryInventoryIdItemsItemIdPatch', () async {
      // TODO
    });

    // Start inventory session
    //
    //Future<InventoryStartResponse> v1InventoryStartPost(StartInventoryRequest startInventoryRequest) async
    test('test v1InventoryStartPost', () async {
      // TODO
    });

  });
}
