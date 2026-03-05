import 'package:nexussklad_openapi_client/src/model/accept_invite_request.dart';
import 'package:nexussklad_openapi_client/src/model/audit_actor.dart';
import 'package:nexussklad_openapi_client/src/model/audit_list_response.dart';
import 'package:nexussklad_openapi_client/src/model/audit_log.dart';
import 'package:nexussklad_openapi_client/src/model/auth_accept_invite_meta.dart';
import 'package:nexussklad_openapi_client/src/model/auth_company.dart';
import 'package:nexussklad_openapi_client/src/model/auth_login_meta.dart';
import 'package:nexussklad_openapi_client/src/model/auth_me_response.dart';
import 'package:nexussklad_openapi_client/src/model/auth_refresh_meta.dart';
import 'package:nexussklad_openapi_client/src/model/auth_register_meta.dart';
import 'package:nexussklad_openapi_client/src/model/auth_session.dart';
import 'package:nexussklad_openapi_client/src/model/auth_session_accept_invite_response.dart';
import 'package:nexussklad_openapi_client/src/model/auth_session_login_response.dart';
import 'package:nexussklad_openapi_client/src/model/auth_session_refresh_response.dart';
import 'package:nexussklad_openapi_client/src/model/auth_session_register_response.dart';
import 'package:nexussklad_openapi_client/src/model/auth_user.dart';
import 'package:nexussklad_openapi_client/src/model/category.dart';
import 'package:nexussklad_openapi_client/src/model/category_list_response.dart';
import 'package:nexussklad_openapi_client/src/model/category_response.dart';
import 'package:nexussklad_openapi_client/src/model/category_update_response.dart';
import 'package:nexussklad_openapi_client/src/model/company.dart';
import 'package:nexussklad_openapi_client/src/model/company_response.dart';
import 'package:nexussklad_openapi_client/src/model/company_update_response.dart';
import 'package:nexussklad_openapi_client/src/model/company_user.dart';
import 'package:nexussklad_openapi_client/src/model/create_adjustment_request.dart';
import 'package:nexussklad_openapi_client/src/model/create_category_request.dart';
import 'package:nexussklad_openapi_client/src/model/create_movement_request.dart';
import 'package:nexussklad_openapi_client/src/model/create_product_request.dart';
import 'package:nexussklad_openapi_client/src/model/create_user_request.dart';
import 'package:nexussklad_openapi_client/src/model/daily_inventory_session.dart';
import 'package:nexussklad_openapi_client/src/model/daily_inventory_session_count.dart';
import 'package:nexussklad_openapi_client/src/model/daily_inventory_session_started_by.dart';
import 'package:nexussklad_openapi_client/src/model/daily_movement_summary_item.dart';
import 'package:nexussklad_openapi_client/src/model/daily_report.dart';
import 'package:nexussklad_openapi_client/src/model/daily_report_inventory.dart';
import 'package:nexussklad_openapi_client/src/model/daily_report_movement_summary.dart';
import 'package:nexussklad_openapi_client/src/model/daily_report_response.dart';
import 'package:nexussklad_openapi_client/src/model/daily_report_stock.dart';
import 'package:nexussklad_openapi_client/src/model/error_response.dart';
import 'package:nexussklad_openapi_client/src/model/error_response_error.dart';
import 'package:nexussklad_openapi_client/src/model/finish_inventory_request.dart';
import 'package:nexussklad_openapi_client/src/model/inventory_finish_response.dart';
import 'package:nexussklad_openapi_client/src/model/inventory_item.dart';
import 'package:nexussklad_openapi_client/src/model/inventory_item_response.dart';
import 'package:nexussklad_openapi_client/src/model/inventory_product.dart';
import 'package:nexussklad_openapi_client/src/model/inventory_response.dart';
import 'package:nexussklad_openapi_client/src/model/inventory_session.dart';
import 'package:nexussklad_openapi_client/src/model/inventory_start_response.dart';
import 'package:nexussklad_openapi_client/src/model/inventory_started_by.dart';
import 'package:nexussklad_openapi_client/src/model/invite_user_request.dart';
import 'package:nexussklad_openapi_client/src/model/invite_user_response.dart';
import 'package:nexussklad_openapi_client/src/model/login_request.dart';
import 'package:nexussklad_openapi_client/src/model/logout_request.dart';
import 'package:nexussklad_openapi_client/src/model/movement_actor.dart';
import 'package:nexussklad_openapi_client/src/model/movement_adjustment_response.dart';
import 'package:nexussklad_openapi_client/src/model/movement_expense_response.dart';
import 'package:nexussklad_openapi_client/src/model/movement_income_response.dart';
import 'package:nexussklad_openapi_client/src/model/movement_list_response.dart';
import 'package:nexussklad_openapi_client/src/model/movement_product.dart';
import 'package:nexussklad_openapi_client/src/model/movement_response.dart';
import 'package:nexussklad_openapi_client/src/model/product.dart';
import 'package:nexussklad_openapi_client/src/model/product_category.dart';
import 'package:nexussklad_openapi_client/src/model/product_list_response.dart';
import 'package:nexussklad_openapi_client/src/model/product_response.dart';
import 'package:nexussklad_openapi_client/src/model/product_update_response.dart';
import 'package:nexussklad_openapi_client/src/model/refresh_request.dart';
import 'package:nexussklad_openapi_client/src/model/register_request.dart';
import 'package:nexussklad_openapi_client/src/model/start_inventory_request.dart';
import 'package:nexussklad_openapi_client/src/model/stock_movement.dart';
import 'package:nexussklad_openapi_client/src/model/stock_report.dart';
import 'package:nexussklad_openapi_client/src/model/stock_report_item.dart';
import 'package:nexussklad_openapi_client/src/model/stock_report_response.dart';
import 'package:nexussklad_openapi_client/src/model/stock_report_summary.dart';
import 'package:nexussklad_openapi_client/src/model/update_category_request.dart';
import 'package:nexussklad_openapi_client/src/model/update_company_request.dart';
import 'package:nexussklad_openapi_client/src/model/update_inventory_item_request.dart';
import 'package:nexussklad_openapi_client/src/model/update_product_request.dart';
import 'package:nexussklad_openapi_client/src/model/update_user_request.dart';
import 'package:nexussklad_openapi_client/src/model/user_list_response.dart';
import 'package:nexussklad_openapi_client/src/model/user_response.dart';
import 'package:nexussklad_openapi_client/src/model/user_update_response.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AcceptInviteRequest':
          return AcceptInviteRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuditActor':
          return AuditActor.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuditListResponse':
          return AuditListResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuditLog':
          return AuditLog.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthAcceptInviteMeta':
          return AuthAcceptInviteMeta.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthCompany':
          return AuthCompany.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthLoginMeta':
          return AuthLoginMeta.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthMeResponse':
          return AuthMeResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthRefreshMeta':
          return AuthRefreshMeta.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthRegisterMeta':
          return AuthRegisterMeta.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthSession':
          return AuthSession.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthSessionAcceptInviteResponse':
          return AuthSessionAcceptInviteResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthSessionLoginResponse':
          return AuthSessionLoginResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthSessionRefreshResponse':
          return AuthSessionRefreshResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthSessionRegisterResponse':
          return AuthSessionRegisterResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthUser':
          return AuthUser.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Category':
          return Category.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CategoryListResponse':
          return CategoryListResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CategoryResponse':
          return CategoryResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CategoryUpdateResponse':
          return CategoryUpdateResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Company':
          return Company.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CompanyResponse':
          return CompanyResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CompanyUpdateResponse':
          return CompanyUpdateResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CompanyUser':
          return CompanyUser.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateAdjustmentRequest':
          return CreateAdjustmentRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateCategoryRequest':
          return CreateCategoryRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateMovementRequest':
          return CreateMovementRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateProductRequest':
          return CreateProductRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateUserRequest':
          return CreateUserRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DailyInventorySession':
          return DailyInventorySession.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DailyInventorySessionCount':
          return DailyInventorySessionCount.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DailyInventorySessionStartedBy':
          return DailyInventorySessionStartedBy.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DailyMovementSummaryItem':
          return DailyMovementSummaryItem.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DailyReport':
          return DailyReport.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DailyReportInventory':
          return DailyReportInventory.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DailyReportMovementSummary':
          return DailyReportMovementSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DailyReportResponse':
          return DailyReportResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DailyReportStock':
          return DailyReportStock.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ErrorResponse':
          return ErrorResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ErrorResponseError':
          return ErrorResponseError.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FinishInventoryRequest':
          return FinishInventoryRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InventoryFinishResponse':
          return InventoryFinishResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InventoryItem':
          return InventoryItem.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InventoryItemResponse':
          return InventoryItemResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InventoryProduct':
          return InventoryProduct.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InventoryResponse':
          return InventoryResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InventorySession':
          return InventorySession.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InventoryStartResponse':
          return InventoryStartResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InventoryStartedBy':
          return InventoryStartedBy.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InventoryStatus':
          
          
        case 'InviteUserRequest':
          return InviteUserRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InviteUserResponse':
          return InviteUserResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginRequest':
          return LoginRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LogoutRequest':
          return LogoutRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MovementActor':
          return MovementActor.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MovementAdjustmentResponse':
          return MovementAdjustmentResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MovementExpenseResponse':
          return MovementExpenseResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MovementIncomeResponse':
          return MovementIncomeResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MovementListResponse':
          return MovementListResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MovementProduct':
          return MovementProduct.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MovementResponse':
          return MovementResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MovementType':
          
          
        case 'Product':
          return Product.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProductCategory':
          return ProductCategory.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProductListResponse':
          return ProductListResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProductResponse':
          return ProductResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProductUpdateResponse':
          return ProductUpdateResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RefreshRequest':
          return RefreshRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RegisterRequest':
          return RegisterRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StartInventoryRequest':
          return StartInventoryRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StockMovement':
          return StockMovement.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StockReport':
          return StockReport.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StockReportItem':
          return StockReportItem.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StockReportResponse':
          return StockReportResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StockReportSummary':
          return StockReportSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateCategoryRequest':
          return UpdateCategoryRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateCompanyRequest':
          return UpdateCompanyRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateInventoryItemRequest':
          return UpdateInventoryItemRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateProductRequest':
          return UpdateProductRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateUserRequest':
          return UpdateUserRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserListResponse':
          return UserListResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserResponse':
          return UserResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserRole':
          
          
        case 'UserUpdateResponse':
          return UserUpdateResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }