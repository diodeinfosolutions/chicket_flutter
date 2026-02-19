/// Syrve Live API Configuration
/// Documentation: https://api-eu.syrve.live/docs
class AppConstants {
  AppConstants._();

  // Base URL
  static const String baseUrl = 'https://api-eu.syrve.live';

  // API Key (Chicket Bahrain)
  static const String apiKey = '754d2940ef4e4282807b48e0d0ceb5d1';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 120);
  static const Duration receiveTimeout = Duration(seconds: 120);
  static const Duration sendTimeout = Duration(seconds: 120);
}
