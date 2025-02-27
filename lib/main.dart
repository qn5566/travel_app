import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:travel/ui/dashboard/dashboard_binding.dart';

import 'config/global_config.dart';
import 'injection_container.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // // 啟用 Firebase
  // await Firebase.initializeApp();

  // init firebase
  await firebaseRepo.init();
  // 請求 Notification permission
  await firebaseRepo.requestNotificationPermission();

  if (kDebugMode) {
    MobileAds.instance.initialize().then((InitializationStatus status) {
      MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: ['83b54b8a4ff6935e8a65d2c940c5c88f'],
      ));
    });
  } else {
    MobileAds.instance.initialize();
  }

  // 啟用 Crashlytics
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    UserUtil.init(context);
    return GetMaterialApp(
      initialBinding: DashboardBinding(),
      initialRoute: AppRoutes.splashPage,
      getPages: AppPages.list,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
    );
  }
}
