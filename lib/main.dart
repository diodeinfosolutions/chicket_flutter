import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:chicket/routes.dart';
import 'package:chicket/init.dart';
import 'package:chicket/utils/kiosk_service.dart';
import 'package:chicket/controllers/idle_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize kiosk mode features
  await KioskService.initKioskMode();
  
  initControllers();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-apply immersive mode when app resumes
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
          theme: ThemeData(
            fontFamily: 'Oswald',
          ),
          initialRoute: Routes.splash,
          getPages: Routes.pages,
          debugShowCheckedModeBanner: kDebugMode,
          // Disable back button globally
            builder: (context, child) {
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  // Block all back navigation
                },
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
