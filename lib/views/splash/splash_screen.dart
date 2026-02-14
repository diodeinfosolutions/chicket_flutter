import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:chicket/routes.dart';
import 'package:chicket/gen/assets.gen.dart';
import 'package:chicket/theme/colors.dart';
import 'package:chicket/controllers/idle_controller.dart';
import 'package:chicket/controllers/syrve_controller.dart';
import 'package:chicket/services/kiosk_config_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final IdleController _idleController;
  late final KioskConfigService _configService;
  late final SyrveController _syrveController;
  late final GifController _gifController;

  late final bool shouldRepeat;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    shouldRepeat = Get.arguments == true;

    _idleController = Get.find<IdleController>();
    _configService = Get.find<KioskConfigService>();
    _syrveController = Get.find<SyrveController>();
    _gifController = GifController();

    _idleController.stopMonitoring();

    if (_configService.isConfigured) {
      _syrveController.initialize();

      if (!shouldRepeat) {
        Future.delayed(const Duration(milliseconds: 750), () {
          if (mounted && !_hasNavigated) {
            _navigateNext();
          }
        });
      }
    }
  }

  void _navigateNext() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    if (!_configService.isConfigured) {
      Get.offAllNamed(Routes.setup);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  void _onTap() {
    if (shouldRepeat) {
      _idleController.onUserInteraction();
    }
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onPanDown: (_) => _onTap(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.RED,
          body: Center(
            child: GifView.asset(
              Assets.gif.chicket.path,
              controller: _gifController,
              fit: BoxFit.cover,
              loop: shouldRepeat,
              onFinish: shouldRepeat ? null : _navigateNext,
            ),
          ),
        ),
      ),
    );
  }
}
