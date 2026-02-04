import 'package:get/get.dart';

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

  Get.put(LanguageController());
  Get.put(SyrveController());

  Get.put(IdleController());
  Get.put(OrderController());
}
