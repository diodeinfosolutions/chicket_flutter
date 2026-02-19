import 'package:get/get.dart';

import 'controllers/banner_controller.dart';
import 'controllers/idle_controller.dart';
import 'controllers/language_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/syrve_controller.dart';
import 'services/kiosk_config_service.dart';
import 'services/menu_cache_service.dart';

Future<void> initControllers() async {
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
