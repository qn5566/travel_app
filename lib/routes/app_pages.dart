import 'package:get/get.dart';
import 'package:travel/ui/search/search_binding.dart';
import 'package:travel/ui/search/search_page.dart';
import 'package:travel/ui/splash/splash_page.dart';
import 'package:travel/ui/webview/webview_page.dart';

import '../ui/dashboard/dashboard_binding.dart';
import '../ui/dashboard/dashboard_page.dart';
import '../ui/detail/detail_binding.dart';
import '../ui/detail/detail_page.dart';
import '../ui/splash/splash_binding.dart';
import '../ui/webview/webview_binding.dart';
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
        name: AppRoutes.travelDetails,
        page: () => const DetailPage(),
        binding: DetailBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.searchPage,
        page: () => const SearchPage(),
        binding: SearchBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.splashPage,
        page: () => const SplashPage(),
        binding: SplashBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.webViewPage,
        page: () => const CustomWebViewPage(),
        binding: CustomWebViewBinding(),
        transition: Transition.rightToLeft),
  ];
}
