import 'package:get/get.dart';

import '../data/api_helper.dart';
import '../data/mode/data_all.dart';

enum SortState { id, title, region, siteLevel }

class HomeController extends GetxController {
  final String title = '旅遊地圖';

  var isLoading = true.obs;
  var dataList = <DataAll>[].obs;

  @override
  void onInit() async {
    super.onInit();
    fetchApi();
  }

  void fetchApi() async {
    isLoading(true);
    await ApiHelper().fetchAllData().then((value) {
      dataList.assignAll(value);
      isLoading(false);
      update();
    }).catchError((e) {});
  }

  // sort method
  void sort(SortState sortState) async {
    switch (sortState) {
      case SortState.title:
        dataList.sort((a, b) => a.title!.compareTo(b.title!));
        break;
      case SortState.id:
        dataList.sort((a, b) => a.id!.compareTo(b.id!));
        break;
      case SortState.region:
        dataList.sort((a, b) => a.region!.compareTo(b.region!));
        break;
      case SortState.siteLevel:
        dataList.sort((a, b) => a.siteLevel!.compareTo(b.siteLevel!));
        break;
    }
    update();
  }
}
