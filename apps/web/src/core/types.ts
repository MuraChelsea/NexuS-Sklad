import type {
  AuthMeResponseDto,
  AuthSessionRouteResponse,
  CompanyDto,
  CompanyUserDto,
  DailyReportDto,
  ProductDto,
  StockMovementDto,
} from '@nexussklad/shared';

export type AuthSessionResponse =
  | AuthSessionRouteResponse<'login'>
  | AuthSessionRouteResponse<'refresh'>
  | AuthSessionRouteResponse<'register'>
  | AuthSessionRouteResponse<'accept-invite'>;

export type CurrentUser = AuthMeResponseDto['user'];
export type Company = CompanyDto;
export type CompanyUser = CompanyUserDto;
export type DailyReport = DailyReportDto;
export type Product = ProductDto;
export type StockMovement = StockMovementDto;
