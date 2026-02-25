import 'package:chicket/api/api_constants.dart';
import 'package:chicket/api/models/models.dart';
import 'package:chicket/api/services/dio_client.dart';
import 'package:chicket/api/services/syrve_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResult.success(this.data) : error = null, isSuccess = true;

  ApiResult.failure(this.error) : data = null, isSuccess = false;
}

class SyrveRepository {
  late final SyrveApiService _apiService;

  String? _accessToken;
  DateTime? _tokenExpiry;

  String? _organizationId;
  String? _terminalGroupId;
  List<OrderType>? _orderTypes;
  List<PaymentType>? _paymentTypes;

  SyrveRepository() {
    _apiService = SyrveApiService(DioClient.instance);
  }

  void setOrganizationId(String orgId) {
    _organizationId = orgId;
  }

  void setTerminalGroupId(String terminalId) {
    _terminalGroupId = terminalId;
  }

  void clearCachedOrderTypes() {
    _orderTypes = null;
  }

  void clearCachedPaymentTypes() {
    _paymentTypes = null;
  }

  String get _bearerToken => 'Bearer $_accessToken';

  bool get _isTokenValid {
    if (_accessToken == null || _tokenExpiry == null) return false;

    return DateTime.now().isBefore(
      _tokenExpiry!.subtract(const Duration(minutes: 5)),
    );
  }

  Future<ApiResult<String>> getAccessToken({bool forceRefresh = false}) async {
    if (!forceRefresh && _isTokenValid) {
      return ApiResult.success(_accessToken!);
    }

    try {
      final response = await _apiService.getAccessToken(
        AccessTokenRequest(apiLogin: AppConstants.apiKey),
      );
      _accessToken = response.token;

      _tokenExpiry = DateTime.now().add(const Duration(minutes: 15));
      return ApiResult.success(response.token);
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting access token: $e');
      return ApiResult.failure('Failed to get access token: $e');
    }
  }

  Future<ApiResult<void>> _ensureToken() async {
    if (!_isTokenValid) {
      final result = await getAccessToken();
      if (!result.isSuccess) {
        return ApiResult.failure(result.error);
      }
    }
    return ApiResult.success(null);
  }

  Future<ApiResult<List<Organization>>> getOrganizations({
    List<String>? organizationIds,
    bool returnAdditionalInfo = true,
    bool includeDisabled = false,
  }) async {
    final tokenResult = await _ensureToken();
    if (!tokenResult.isSuccess) return ApiResult.failure(tokenResult.error);

    try {
      final response = await _apiService.getOrganizations(
        _bearerToken,
        OrganizationsRequest(
          organizationIds: organizationIds,
          returnAdditionalInfo: returnAdditionalInfo,
          includeDisabled: includeDisabled,
        ),
      );

      if (response.organizations.isNotEmpty && _organizationId == null) {
        _organizationId = response.organizations.first.id;
      }

      return ApiResult.success(response.organizations);
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting organizations: $e');
      return ApiResult.failure('Failed to get organizations: $e');
    }
  }

  Future<ApiResult<String>> getOrganizationId() async {
    if (_organizationId != null) {
      return ApiResult.success(_organizationId!);
    }

    final result = await getOrganizations();
    if (result.isSuccess && result.data != null && result.data!.isNotEmpty) {
      _organizationId = result.data!.first.id;
      return ApiResult.success(_organizationId!);
    }
    return ApiResult.failure(result.error ?? 'No organizations found');
  }

  Future<ApiResult<List<TerminalGroup>>> getTerminalGroups({
    required List<String> organizationIds,
    bool includeDisabled = false,
  }) async {
    final tokenResult = await _ensureToken();
    if (!tokenResult.isSuccess) return ApiResult.failure(tokenResult.error);

    try {
      final response = await _apiService.getTerminalGroups(
        _bearerToken,
        TerminalGroupsRequest(
          organizationIds: organizationIds,
          includeDisabled: includeDisabled,
        ),
      );

      final allTerminals = <TerminalGroup>[];
      for (final orgGroup in response.terminalGroups) {
        allTerminals.addAll(orgGroup.items);
      }

      if (allTerminals.isNotEmpty && _terminalGroupId == null) {
        _terminalGroupId = allTerminals.first.id;
      }

      return ApiResult.success(allTerminals);
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting terminal groups: $e');
      return ApiResult.failure('Failed to get terminal groups: $e');
    }
  }

  Future<ApiResult<String>> getTerminalGroupId() async {
    if (_terminalGroupId != null) {
      return ApiResult.success(_terminalGroupId!);
    }

    final orgResult = await getOrganizationId();
    if (!orgResult.isSuccess) return ApiResult.failure(orgResult.error);

    final result = await getTerminalGroups(organizationIds: [orgResult.data!]);
    if (result.isSuccess && result.data != null && result.data!.isNotEmpty) {
      _terminalGroupId = result.data!.first.id;
      return ApiResult.success(_terminalGroupId!);
    }
    return ApiResult.failure(result.error ?? 'No terminal groups found');
  }

  Future<ApiResult<List<OrderType>>> getOrderTypes({
    required List<String> organizationIds,
  }) async {
    if (_orderTypes != null && _orderTypes!.isNotEmpty) {
      return ApiResult.success(_orderTypes!);
    }

    final tokenResult = await _ensureToken();
    if (!tokenResult.isSuccess) return ApiResult.failure(tokenResult.error);

    try {
      final response = await _apiService.getOrderTypes(
        _bearerToken,
        OrderTypesRequest(organizationIds: organizationIds),
      );

      final allOrderTypes = <OrderType>[];
      for (final orgTypes in response.orderTypes) {
        allOrderTypes.addAll(orgTypes.items);
      }

      _orderTypes = allOrderTypes;
      return ApiResult.success(allOrderTypes);
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting order types: $e');
      return ApiResult.failure('Failed to get order types: $e');
    }
  }

  Future<ApiResult<List<PaymentType>>> getPaymentTypes({
    required List<String> organizationIds,
  }) async {
    if (_paymentTypes != null && _paymentTypes!.isNotEmpty) {
      return ApiResult.success(_paymentTypes!);
    }

    final tokenResult = await _ensureToken();
    if (!tokenResult.isSuccess) return ApiResult.failure(tokenResult.error);

    try {
      final response = await _apiService.getPaymentTypes(
        _bearerToken,
        PaymentTypesRequest(organizationIds: organizationIds),
      );

      _paymentTypes = response.paymentTypes;
      return ApiResult.success(response.paymentTypes);
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting payment types: $e');
      return ApiResult.failure('Failed to get payment types: $e');
    }
  }

  Future<ApiResult<List<ExternalMenu>>> getExternalMenus({
    required String organizationId,
  }) async {
    final tokenResult = await _ensureToken();
    if (!tokenResult.isSuccess) return ApiResult.failure(tokenResult.error);

    try {
      final response = await _apiService.getExternalMenus(
        _bearerToken,
        MenuRequest(organizationId: organizationId),
      );
      return ApiResult.success(response.externalMenus ?? []);
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting external menus: $e');
      return ApiResult.failure('Failed to get external menus: $e');
    }
  }

  /*
  Future<ApiResult<MenuResponse>> getMenu({
    required String organizationId,
    int? externalMenuId,
  }) async {
    final tokenResult = await _ensureToken();
    if (!tokenResult.isSuccess) return ApiResult.failure(tokenResult.error);

    try {
      int menuId;

      if (externalMenuId != null) {
        menuId = externalMenuId;
      } else if (_externalMenuId != null) {
        menuId = _externalMenuId!;
        if (kDebugMode) debugPrint('Using cached external menu ID: $menuId');
      } else {
        final externalMenusResult = await getExternalMenus(
          organizationId: organizationId,
        );
        if (!externalMenusResult.isSuccess) {
          return ApiResult.failure(externalMenusResult.error);
        }

        final externalMenus = externalMenusResult.data!;
        if (externalMenus.isEmpty) {
          return ApiResult.failure(
            'No external menus configured for this organization',
          );
        }

        menuId = externalMenus.first.id;
        if (kDebugMode) {
          debugPrint(
            'Using external menu: ${externalMenus.first.name} (ID: $menuId)',
          );
        }
      }

      final response = await _apiService.getMenuById(
        _bearerToken,
        MenuByIdRequest(
          externalMenuId: menuId,
          organizationIds: [organizationId],
        ),
      );
      return ApiResult.success(response);
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting menu: $e');
      return ApiResult.failure('Failed to get menu: $e');
    }
  }
  */

  Future<ApiResult<List<String>>> getStopListProductIds({
    required List<String> organizationIds,
  }) async {
    final tokenResult = await _ensureToken();
    if (!tokenResult.isSuccess) return ApiResult.failure(tokenResult.error);

    try {
      final response = await _apiService.getStopLists(
        _bearerToken,
        StopListRequest(organizationIds: organizationIds),
      );

      final stoppedProductIds = <String>{};
      for (final terminalGroupStopList in response.terminalGroupStopLists) {
        for (final item in terminalGroupStopList.items) {
          for (final product in item.items) {
            stoppedProductIds.add(product.productId);
          }
        }
      }

      return ApiResult.success(stoppedProductIds.toList());
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting stop lists: $e');
      return ApiResult.failure('Failed to get stop lists: $e');
    }
  }

  Future<ApiResult<CreateDeliveryResponse>> createDeliveryOrder({
    required String organizationId,
    String? terminalGroupId,
    required DeliveryOrder order,
    int? transportToFrontTimeout,
  }) async {
    final tokenResult = await _ensureToken();
    if (!tokenResult.isSuccess) return ApiResult.failure(tokenResult.error);

    try {
      if (kDebugMode) debugPrint('Creating order with payload:');
      if (kDebugMode) debugPrint('  organizationId: $organizationId');
      if (kDebugMode) debugPrint('  terminalGroupId: $terminalGroupId');
      if (kDebugMode) debugPrint('  orderTypeId: ${order.orderTypeId}');
      if (kDebugMode) {
        debugPrint('  orderServiceType: ${order.orderServiceType}');
      }
      if (kDebugMode) debugPrint('  items count: ${order.items.length}');
      if (kDebugMode) debugPrint('  phone: ${order.phone}');

      final response = await _apiService.createDelivery(
        _bearerToken,
        CreateDeliveryRequest(
          organizationId: organizationId,
          terminalGroupId: terminalGroupId,
          order: order,
          createOrderSettings: transportToFrontTimeout != null
              ? CreateOrderSettings(
                  transportToFrontTimeout: transportToFrontTimeout,
                )
              : null,
        ),
      );
      return ApiResult.success(response);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      String errorMessage = 'Failed to create order';

      if (responseData is Map<String, dynamic>) {
        final errorDescription =
            responseData['errorDescription'] ??
            responseData['message'] ??
            responseData['error'];
        if (errorDescription != null) {
          errorMessage = errorDescription.toString();
        }
        if (kDebugMode) debugPrint('API Error Response: $responseData');
      } else if (responseData != null) {
        errorMessage = responseData.toString();
        if (kDebugMode) debugPrint('API Error: $errorMessage');
      }

      if (kDebugMode) debugPrint('DioException: ${e.message}');
      if (kDebugMode) debugPrint('Status Code: ${e.response?.statusCode}');
      return ApiResult.failure(errorMessage);
    } catch (e) {
      if (kDebugMode) debugPrint('Error creating delivery: $e');
      return ApiResult.failure('Failed to create delivery: $e');
    }
  }

  Future<ApiResult<List<OrderInfo>>> retrieveDeliveryById({
    required String organizationId,
    required List<String> orderIds,
    List<String>? sourceKeys,
  }) async {
    final tokenResult = await _ensureToken();
    if (!tokenResult.isSuccess) return ApiResult.failure(tokenResult.error);

    try {
      final response = await _apiService.retrieveDeliveryById(
        _bearerToken,
        RetrieveDeliveryRequest(
          organizationId: organizationId,
          orderIds: orderIds,
          sourceKeys: sourceKeys,
        ),
      );
      return ApiResult.success(response.orders ?? []);
    } catch (e) {
      if (kDebugMode) debugPrint('Error retrieving delivery: $e');
      return ApiResult.failure('Failed to retrieve delivery: $e');
    }
  }

  Future<ApiResult<void>> initializeStaticData() async {
    try {
      final orgResult = await getOrganizationId();
      if (!orgResult.isSuccess) return ApiResult.failure(orgResult.error);

      final orgId = orgResult.data!;

      final results = await Future.wait([
        getTerminalGroups(organizationIds: [orgId]),
        getOrderTypes(organizationIds: [orgId]),
        getPaymentTypes(organizationIds: [orgId]),
      ]);

      for (final result in results) {
        if (!result.isSuccess) {
          return ApiResult.failure(result.error);
        }
      }

      if (kDebugMode) {
        debugPrint('Static data initialized successfully');
        debugPrint('Organization ID: $_organizationId');
        debugPrint('Terminal Group ID: $_terminalGroupId');
        debugPrint('Order Types: ${_orderTypes?.length}');
        debugPrint('Payment Types: ${_paymentTypes?.length}');
      }

      return ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure('Failed to initialize static data: $e');
    }
  }

  void clearCache() {
    _accessToken = null;
    _tokenExpiry = null;
    _organizationId = null;
    _terminalGroupId = null;
    _orderTypes = null;
    _paymentTypes = null;
  }

  String? get organizationId => _organizationId;
  String? get terminalGroupId => _terminalGroupId;
  List<OrderType>? get cachedOrderTypes => _orderTypes;
  List<PaymentType>? get cachedPaymentTypes => _paymentTypes;
}
