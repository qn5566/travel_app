import 'package:get/get.dart';

import 'global_config.dart';
import '../data/mode/recommend_app_model.dart';

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
    if (recommendApp.isEmpty) recommendApp.assignAll(defaultRecommendApp);
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

  /// info.json 無法取得時仍可使用的景點資料鏡像。
  static const fallbackDataApi = <String>[
    'https://raw.githubusercontent.com/qn5566/travel/main/data/Attraction-json.zip',
  ];

  static final defaultRecommendApp = <RecommendAppModel>[
    RecommendAppModel(
      title: 'Baby Learn English｜遊戲學 ABC',
      subtitle: '邊玩邊學，輕鬆認識英文字母',
      image:
          'https://raw.githubusercontent.com/qn5566/ActivityEvent/main/res/images/pics/ads_banner_4.webp',
      imageHeight: 76,
      url: 'https://qn5566.github.io/BabayLearnEnglish/',
    ),
    RecommendAppModel(
      title: 'HiMyDream 親子台灣旅遊部落客',
      subtitle: '親子共遊靈感與實用攻略',
      image:
          'https://raw.githubusercontent.com/qn5566/travel/main/res/images/pics/ads_banner_1.webp',
      imageHeight: 76,
      url: 'https://himydream.me/',
    ),
    RecommendAppModel(
      title: '台灣吃喝玩樂地圖 APP',
      subtitle: '景點、美食、路線一手掌握',
      image:
          'https://raw.githubusercontent.com/qn5566/travel/main/res/images/pics/ads_banner_2.webp',
      imageHeight: 76,
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.meetstudio.event',
      iosUrl: 'https://apps.apple.com/us/app/id6446348643',
    ),
    RecommendAppModel(
      title: '寵物領養紀錄 APP',
      subtitle: '給毛小孩最完整的陪伴紀錄',
      image:
          'https://raw.githubusercontent.com/qn5566/travel/main/res/images/pics/ads_banner_3.webp',
      imageHeight: 76,
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.meetstudio.app.adoptpet',
      iosUrl: 'https://apps.apple.com/us/app/id6737406473',
    ),
    RecommendAppModel(
      title: '幫忙打分給予支持，大感謝',
      subtitle: '你的肯定就是我們前進的動力',
      image:
          'https://raw.githubusercontent.com/qn5566/travel/main/res/images/icon/rate_us.webp',
      imageHeight: 40,
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.meetstudio.travel&reviewId=0',
      iosUrl: 'https://apps.apple.com/us/app/id1671108420?action=write-review',
    ),
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

  // 相關 App 推薦
  RxList<RecommendAppModel> recommendApp = <RecommendAppModel>[].obs;
}
