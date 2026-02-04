import 'package:chicket/views/cart/cart_screen.dart';
import 'package:chicket/views/confirmed/confirmed_screen.dart';
import 'package:chicket/views/menu/menu_screen.dart';
import 'package:chicket/views/mob/mob_screen.dart';
import 'package:chicket/views/order_processing/order_processing_screen.dart';
import 'package:chicket/views/select_payment/select_payment_screen.dart';
import 'package:get/get.dart';

import 'views/homepage/homepage.dart';
import 'views/splash/splash_screen.dart';

class Routes {
  static const splash = '/';
  static const home = '/home';
  static const menu = '/menu';
  static const cart = '/cart';
  static const mob = '/mob';
  static const selectPayment = '/selectPayemnt';
  static const orderProcessing = '/orderProcessing';
  static const confirmed = '/confirmed';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: menu, page: () => const MenuScreen()),
    GetPage(name: cart, page: () => const CartScreen()),
    GetPage(name: mob, page: () => const MobScreen()),
    GetPage(name: selectPayment, page: () => const SelectPaymentScreen()),
    GetPage(name: orderProcessing, page: () => const OrderProcessingScreen()),
    GetPage(name: confirmed, page: () => const ConfirmedScreen()),
  ];
}
