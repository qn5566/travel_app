import 'package:get/get.dart';

import 'global_config.dart';

class RxConfig extends GetxController {
  RxConfig() {
    final savedVersion =
        sharedPreferences.getInt(AppConstants.remoteHomeDataVersionKey);
    if (savedVersion != null && savedVersion > 0) {
      dataVersion.value = savedVersion;
    }
    initializeDefaults();
  }

  void initializeDefaults() {
    if (travelTitle.isEmpty) travelTitle.assignAll(defaultTravelTitles);
    if (keyWordTravel.isEmpty) keyWordTravel.assignAll(defaultKeywords);
    if (dataAPI.isEmpty) dataAPI.assignAll(defaultDataApi);
  }

  static const defaultTravelTitles = <String>[
    '臺北市',
    '基隆市',
    '臺中市',
    '高雄市',
    '澎湖縣',
    '臺南市',
    '金門縣',
    '屏東縣',
    '新竹市',
    '新竹縣',
    '桃園市',
    '苗栗縣',
    '臺東縣',
    '彰化縣',
    '南投縣',
    '花蓮縣',
    '新北市',
    '連江縣',
    '宜蘭縣',
    '嘉義市',
    '嘉義縣',
    '雲林縣',
  ];
  static const defaultKeywords = <String>['公園', '夜市'];
  static const defaultDataApi = <String>[
    'https://media.taiwan.net.tw/XMLReleaseALL_public/v2.0/Zh_tw/Attraction-json.zip',
  ];
  // tab Title
  RxList<String> travelTitle = <String>[].obs;

  // 搜尋關鍵字
  RxList<String> keyWordTravel = <String>[].obs;

  // 資料API
  RxList<String> dataAPI = <String>[].obs;

  /// Required local SQL/data snapshot version from info.json. This is loaded
  /// separately for iOS and Android by SplashController.
  final RxInt dataVersion = AppConstants.homeDataVersion.obs;

  // 設定頁面的訊息
  RxString option = "".obs;

  // 小訣竅
  RxList<String> infoMenu = <String>[].obs;
}
