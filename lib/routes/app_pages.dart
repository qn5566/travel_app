import 'package:get/get.dart';

import '../ui/dashboard/dashboard_binding.dart';
import '../ui/dashboard/dashboard_page.dart';
import '../ui/detail/detail_binding.dart';
import '../ui/detail/detail_page.dart';
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
      page: () => DetailPage(),
      binding: DetailBinding(),
      transition: Transition.rightToLeft
    ),
  ];
}
