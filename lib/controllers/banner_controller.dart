import 'package:get/get.dart';
import 'package:chicket/api/models/banner_models.dart';
import 'package:chicket/api/repositories/api_repository.dart';

class BannerController extends GetxController {
  final ApiRepository _apiRepository = ApiRepository();
  final RxList<BannerData> banners = <BannerData>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

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
    } finally {
      isLoading.value = false;
    }
  }
}
