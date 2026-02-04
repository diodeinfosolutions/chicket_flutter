import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chicket/constants.dart';
import 'package:chicket/routes.dart';
import 'package:chicket/controllers/order_controller.dart';

class IdleController extends GetxController {
  Timer? _idleTimer;
  final isFirstLaunch = true.obs;
  final isIdle = false.obs;

  void resetIdleTimer() {
    _idleTimer?.cancel();
    isIdle.value = false;

    _idleTimer = Timer(AppConstants.idleTimeout, () {
      isIdle.value = true;
      _clearCartOnIdle();
      Get.offAllNamed(Routes.splash);
    });
  }

  void _clearCartOnIdle() {
    if (Get.isRegistered<OrderController>()) {
      final orderController = Get.find<OrderController>();
      orderController.resetSelection();
    }
  }

  void onUserInteraction() {
    if (isIdle.value) {
      isIdle.value = false;
      Get.offAllNamed(Routes.home);
    } else {
      resetIdleTimer();
    }
  }

  void onFirstLaunchComplete() {
    isFirstLaunch.value = false;
    resetIdleTimer();
  }

  void startMonitoring() {
    resetIdleTimer();
  }

  void stopMonitoring() {
    _idleTimer?.cancel();
  }

  @override
  void onClose() {
    _idleTimer?.cancel();
    super.onClose();
  }
}

/// Wrap at the ROOT level (MyApp) for kiosk apps.
/// Uses Listener instead of GestureDetector to avoid
/// interfering with child widget gestures.
class IdleDetector extends StatelessWidget {
  final Widget child;

  const IdleDetector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final idleController = Get.find<IdleController>();

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => idleController.onUserInteraction(),
      onPointerMove: (_) => idleController.onUserInteraction(),
      child: child,
    );
  }
}
