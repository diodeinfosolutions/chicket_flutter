import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chicket/routes.dart';
import 'package:chicket/init.dart';
import 'package:chicket/utils/kiosk_service.dart';
import 'package:chicket/utils/cache_config.dart';
import 'package:chicket/controllers/idle_controller.dart';
import 'package:chicket/localization/app_translations.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  CacheConfig.configure();

  await Hive.initFlutter();
  await Future.wait([KioskService.initKioskMode(), initControllers()]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _initPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = '${info.version}+${info.buildNumber}';
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      KioskService.reapplyImmersiveMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IdleDetector(
      child: ScreenUtilInit(
        designSize: const Size(1080, 1920),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Chicket Kiosk',
            theme: ThemeData(fontFamily: 'Oswald'),
            initialRoute: Routes.splash,
            getPages: Routes.pages,
            debugShowCheckedModeBanner: kDebugMode,
            translations: AppTranslations(),
            locale: Get.deviceLocale?.languageCode == 'ar'
                ? const Locale('ar')
                : const Locale('en'),
            fallbackLocale: const Locale('en'),
            builder: (context, child) {
              final isArabic = Get.locale?.languageCode == 'ar';
              return Directionality(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Stack(
                  children: [
                    child ?? const SizedBox.shrink(),
                    if (_version.isNotEmpty)
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            _version,
                            style: const TextStyle(
                              fontSize: 6,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
