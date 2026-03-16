import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chicket/constants.dart';
import 'package:chicket/routes.dart';
import 'package:chicket/controllers/order_controller.dart';

/// Controller that monitors user inactivity and triggers an idle state.
/// When idle occurs, it clears the cart and returns to the splash screen.
class IdleController extends GetxController {
  Timer? _idleTimer;

  /// Indicates if the application is currently in an idle state.
  final isIdle = false.obs;

  /// Starts the inactivity monitoring timer.
  void startMonitoring() {
    resetIdleTimer();
  }

  /// Resets the countdown timer used to detect inactivity.
  void resetIdleTimer() {
    _idleTimer?.cancel();
    isIdle.value = false;

    _idleTimer = Timer(AppConstants.idleTimeout, _handleTimeout);
  }

  /// Handles the scenario where the inactivity timer reaches its limit.
  void _handleTimeout() {
    isIdle.value = true;
    _idleTimer?.cancel();
    _clearCartOnIdle();
    Get.offAllNamed(Routes.splash, arguments: true);
  }

  /// Stops the inactivity monitoring.
  void stopMonitoring() {
    _idleTimer?.cancel();
  }

  /// Utility to reset order state when timeout occurs.
  void _clearCartOnIdle() {
    if (Get.isRegistered<OrderController>()) {
      final orderController = Get.find<OrderController>();
      orderController.resetSelection();
    }
  }

  /// Triggers a refresh of the monitoring state based on direct user input.
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

/// A wrapper widget that listens for touch interactions to reset the global idle state.
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
