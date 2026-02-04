import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:chicket/api/models/models.dart';

part 'syrve_api_service.g.dart';

/// Syrve Live API Service
/// Documentation: https://api-eu.syrve.live/docs
@RestApi()
abstract class SyrveApiService {
  factory SyrveApiService(Dio dio, {String baseUrl}) = _SyrveApiService;

  /// Get access token
  /// POST /api/1/access_token
  @POST('/api/1/access_token')
  Future<AccessTokenResponse> getAccessToken(
    @Body() AccessTokenRequest request,
  );

  /// Get organizations
  /// POST /api/1/organizations
  @POST('/api/1/organizations')
  Future<OrganizationsResponse> getOrganizations(
    @Header('Authorization') String token,
    @Body() OrganizationsRequest request,
  );

  /// Get terminal groups
  /// POST /api/1/terminal_groups
  @POST('/api/1/terminal_groups')
  Future<TerminalGroupsResponse> getTerminalGroups(
    @Header('Authorization') String token,
    @Body() TerminalGroupsRequest request,
  );

  /// Get order types
  /// POST /api/1/deliveries/order_types
  @POST('/api/1/deliveries/order_types')
  Future<OrderTypesResponse> getOrderTypes(
    @Header('Authorization') String token,
    @Body() OrderTypesRequest request,
  );

  /// Get payment types
  /// POST /api/1/payment_types
  @POST('/api/1/payment_types')
  Future<PaymentTypesResponse> getPaymentTypes(
    @Header('Authorization') String token,
    @Body() PaymentTypesRequest request,
  );

  /// Get external menus list
  /// POST /api/2/menu
  /// Returns available external menus for the organization
  @POST('/api/2/menu')
  Future<ExternalMenusResponse> getExternalMenus(
    @Header('Authorization') String token,
    @Body() MenuRequest request,
  );

  /// Get menu by external menu ID
  /// POST /api/2/menu/by_id
  /// Returns actual menu items (categories and products)
  @POST('/api/2/menu/by_id')
  Future<MenuResponse> getMenuById(
    @Header('Authorization') String token,
    @Body() MenuByIdRequest request,
  );

  /// Get stop lists (out of stock items)
  /// POST /api/1/stop_lists
  @POST('/api/1/stop_lists')
  Future<StopListResponse> getStopLists(
    @Header('Authorization') String token,
    @Body() StopListRequest request,
  );

  /// Create delivery order
  /// POST /api/1/deliveries/create
  @POST('/api/1/deliveries/create')
  Future<CreateDeliveryResponse> createDelivery(
    @Header('Authorization') String token,
    @Body() CreateDeliveryRequest request,
  );

  /// Retrieve delivery by ID
  /// POST /api/1/deliveries/by_id
  @POST('/api/1/deliveries/by_id')
  Future<RetrieveDeliveryResponse> retrieveDeliveryById(
    @Header('Authorization') String token,
    @Body() RetrieveDeliveryRequest request,
  );
}
