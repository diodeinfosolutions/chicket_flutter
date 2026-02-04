import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class KioskService {
  static const MethodChannel _channel = MethodChannel(
    'com.diode.chicket/kiosk',
  );

  static Future<void> initKioskMode() async {
    await enableImmersiveMode();
    await enableWakeLock();
    await startLockTask();
  }

  static Future<void> enableImmersiveMode() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  static Future<void> enableWakeLock() async {
    await WakelockPlus.enable();
  }

  static Future<void> disableWakeLock() async {
    await WakelockPlus.disable();
  }

  static Future<void> startLockTask() async {
    try {
      await _channel.invokeMethod('startLockTask');
    } on PlatformException catch (_) {}
  }

  static Future<void> stopLockTask() async {
    try {
      await _channel.invokeMethod('stopLockTask');
    } on PlatformException catch (_) {}
  }

  static Future<void> reapplyImmersiveMode() async {
    await enableImmersiveMode();
  }
}
