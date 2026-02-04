import 'package:get/get.dart';

import 'controllers/idle_controller.dart';
import 'controllers/order_controller.dart';

void initControllers() {
  Get.put(IdleController());
  Get.put(OrderController());
}
