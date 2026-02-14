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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final IdleController _idleController;
  late final KioskConfigService _configService;
  late final SyrveController _syrveController;
  late final GifController _gifController;
  late final AnimationController _shiftController;
  late final Animation<Offset> _shiftAnimation;

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

    _shiftController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 10),
    )..repeat(reverse: true);

    _shiftAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.5, 0.5)).animate(
          CurvedAnimation(parent: _shiftController, curve: Curves.easeInOut),
        );

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
    _shiftController.dispose();
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
            child: shouldRepeat
                ? AnimatedBuilder(
                    animation: _shiftAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: _shiftAnimation.value,
                        child: child,
                      );
                    },
                    child: GifView.asset(
                      Assets.gif.chicket.path,
                      controller: _gifController,
                      fit: BoxFit.cover,
                      loop: shouldRepeat,
                      onFinish: shouldRepeat ? null : _navigateNext,
                    ),
                  )
                : GifView.asset(
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
