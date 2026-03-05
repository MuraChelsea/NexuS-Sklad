import 'package:test/test.dart';
import 'package:nexussklad_openapi_client/nexussklad_openapi_client.dart';


/// tests for MovementsApi
void main() {
  final instance = NexusSkladOpenapiClient().getMovementsApi();

  group(MovementsApi, () {
    // Create adjustment movement
    //
    //Future<MovementAdjustmentResponse> v1MovementsAdjustmentPost(CreateAdjustmentRequest createAdjustmentRequest) async
    test('test v1MovementsAdjustmentPost', () async {
      // TODO
    });

    // Create expense movement
    //
    //Future<MovementExpenseResponse> v1MovementsExpensePost(CreateMovementRequest createMovementRequest) async
    test('test v1MovementsExpensePost', () async {
      // TODO
    });

    // List movements
    //
    //Future<MovementListResponse> v1MovementsGet({ String productId, MovementType movementType, int limit }) async
    test('test v1MovementsGet', () async {
      // TODO
    });

    // Create income movement
    //
    //Future<MovementIncomeResponse> v1MovementsIncomePost(CreateMovementRequest createMovementRequest) async
    test('test v1MovementsIncomePost', () async {
      // TODO
    });

  });
}
