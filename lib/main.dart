import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:travel/ui/dashboard/dashboard_binding.dart';

import 'config/global_config.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // 啟用 Firebase
  await Firebase.initializeApp();
  // 啟用 Crashlytics
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Firebase 初始設定
  Future<void> initializeDefault() async {
    FirebaseApp app;
    if (Platform.isAndroid) {
      app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      app = await Firebase.initializeApp();
    }

    if (kDebugMode) {
      print('Initialized default app $app');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    UserUtil.init(context);
    initializeDefault();
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
