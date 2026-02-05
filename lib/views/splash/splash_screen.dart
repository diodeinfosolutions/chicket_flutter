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
  late final bool _isFirstLaunch;
  late final GifController _gifController;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _idleController = Get.find<IdleController>();
    _configService = Get.find<KioskConfigService>();
    _syrveController = Get.find<SyrveController>();
    _isFirstLaunch = _idleController.isFirstLaunch.value;
    _gifController = GifController();

    if (_configService.isConfigured) {
      _syrveController.initialize();
      
      // If already configured (returning from setup), navigate after a short delay
      if (!_isFirstLaunch) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && !_hasNavigated) {
            _navigateToNextScreen();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  void _onGifFinish() {
    if (_isFirstLaunch && mounted && !_hasNavigated) {
      _idleController.onFirstLaunchComplete();
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    
    if (!_configService.isConfigured) {
      Get.offAllNamed(Routes.setup);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  void _onTap() {
    if (!_isFirstLaunch) {
      _idleController.onUserInteraction();
    }
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
              onFinish: _onGifFinish,
              fit: BoxFit.cover,
              loop: !_isFirstLaunch,
            ),
          ),
        ),
      ),
    );
  }
}
