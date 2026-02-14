import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chicket/constants.dart';
import 'package:chicket/routes.dart';
import 'package:chicket/controllers/order_controller.dart';

class IdleController extends GetxController {
  Timer? _idleTimer;
  final isIdle = false.obs;

  void startMonitoring() {
    resetIdleTimer();
  }

  void resetIdleTimer() {
    _idleTimer?.cancel();
    isIdle.value = false;

    _idleTimer = Timer(AppConstants.idleTimeout, _handleTimeout);
  }

  void _handleTimeout() {
    isIdle.value = true;
    _idleTimer?.cancel();
    _clearCartOnIdle();
    Get.offAllNamed(Routes.splash, arguments: true);
  }

  void stopMonitoring() {
    _idleTimer?.cancel();
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

  @override
  void onClose() {
    _idleTimer?.cancel();
    super.onClose();
  }
}

class IdleDetector extends StatefulWidget {
  final Widget child;

  const IdleDetector({super.key, required this.child});

  @override
  State<IdleDetector> createState() => _IdleDetectorState();
}

class _IdleDetectorState extends State<IdleDetector> {
  final idleController = Get.find<IdleController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      idleController.startMonitoring();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => idleController.onUserInteraction(),
      onPointerMove: (_) => idleController.onUserInteraction(),
      child: widget.child,
    );
  }
}
