import 'package:get/get.dart';

class RxConfig extends GetxController {
  // tab Title
  RxList<String> travelTitle = <String>[].obs;

  // 搜尋關鍵字
  RxList<String> keyWordTravel = <String>[].obs;

  // 資料API
  RxList<String> dataAPI = <String>[].obs;

  // 設定頁面的訊息
  RxString option = "".obs;

  // 小訣竅
  RxList<String> infoMenu = <String>[].obs;
}
