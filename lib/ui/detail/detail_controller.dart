import 'package:get/get.dart';

class DetailController extends GetxController {
  var counter = 0.obs;

  // late TabController _tabController;

  /// 子分類
  static List<String> subTitle = ['詳情', '評論'];

  @override
  void onInit() async {
    super.onInit();
    // _tabController = TabController(length: subTitle.length, initialIndex: 0, vsync: null);
  }

  void increaseCounter() {
    counter.value += 1;
  }
}
