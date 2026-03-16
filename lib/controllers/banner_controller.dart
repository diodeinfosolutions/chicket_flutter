import 'package:get/get.dart';
import 'package:chicket/api/models/banner_models.dart';
import 'package:chicket/api/repositories/api_repository.dart';
import '../utils/log_local.dart';

/// Controller for fetching and managing promotional banners.
class BannerController extends GetxController {
  final ApiRepository _apiRepository = ApiRepository();

  /// The list of banners currently available for display.
  final RxList<BannerData> banners = <BannerData>[].obs;

  /// Loading status for the banner fetch operation.
  final RxBool isLoading = false.obs;

  /// Error message if the banner fetch fails.
  final RxnString error = RxnString();

  /// Fetches banners for a specific organization and terminal group.
  Future<void> fetchBanners({
    required String organizationId,
    required String terminalGroupId,
  }) async {
    isLoading.value = true;
    error.value = null;
    try {
      final response = await _apiRepository.getBanner(
        organizationId: organizationId,
        terminalGroupId: terminalGroupId,
      );
      banners.assignAll(response.data ?? []);
    } catch (e) {
      error.value = e.toString();
      logLocal('BannerController fetchBanners error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
