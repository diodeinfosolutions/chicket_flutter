/// Syrve Live API Configuration
/// Documentation: https://api-eu.syrve.live/docs
class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://api-eu.syrve.live';

  // API Key (Chicket Bahrain)
  static const String apiKey = '754d2940ef4e4282807b48e0d0ceb5d1';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints
  static const String accessToken = '/api/1/access_token';
  static const String organizations = '/api/1/organizations';
  static const String terminalGroups = '/api/1/terminal_groups';
  static const String orderTypes = '/api/1/deliveries/order_types';
  static const String paymentTypes = '/api/1/payment_types';
  static const String menu = '/api/2/menu';
  static const String menuById = '/api/2/menu/by_id';
  static const String stopLists = '/api/1/stop_lists';
  static const String createDelivery = '/api/1/deliveries/create';
  static const String retrieveDelivery = '/api/1/deliveries/by_id';
  static const String deliveriesByDeliveryDate =
      '/api/1/deliveries/by_delivery_date_and_status';

  // Cache keys for static IDs
  static const String orgIdCacheKey = 'syrve_organization_id';
  static const String terminalIdCacheKey = 'syrve_terminal_id';
  static const String orderTypesCacheKey = 'syrve_order_types';
  static const String paymentTypesCacheKey = 'syrve_payment_types';
}
