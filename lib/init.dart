import 'package:get/get.dart';

import 'controllers/banner_controller.dart';
import 'controllers/idle_controller.dart';
import 'controllers/language_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/syrve_controller.dart';
import 'services/kiosk_config_service.dart';
import 'services/menu_cache_service.dart';

import 'api/repositories/apex_ecr_repository.dart';
import 'api/repositories/api_repository.dart';
import 'controllers/apex_ecr_controller.dart';

Future<void> initControllers() async {
  Get.put(ApiRepository(), permanent: true);
  Get.put(ApexEcrRepository(), permanent: true);
  Get.put(ApexEcrController(), permanent: true);

  final configService = await KioskConfigService().init();
  Get.put(configService);

  final cacheService = await MenuCacheService().init();
  Get.put(cacheService);

  Get.put(LanguageController(), permanent: true);
  Get.put(BannerController(), permanent: true);
  Get.put(SyrveController(), permanent: true);

  Get.put(IdleController(), permanent: true);
  Get.put(OrderController(), permanent: true);
}
