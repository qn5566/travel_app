import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/config/rx_config.dart';

import 'config/global_config.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  Get.put(RxConfig());
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    UserUtil.init(context);
    return GetMaterialApp(
      initialRoute: AppRoutes.splashPage,
      getPages: AppPages.list,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
    );
  }
}
