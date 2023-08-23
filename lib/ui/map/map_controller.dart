import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:location/location.dart';

import '../../config/AdHelper.dart';
import '../../config/global_config.dart';
import '../../data/dao/dataAllDao.dart';
import '../../data/mode/data_all.dart';
import '../../data/repo/data_repo.dart';
import '../../data/repo/fxDataBaseManager.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_marker.dart';

class MapController extends GetxController {
  /// FirebaseAnalytics
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Completer<GoogleMapController> mapController = Completer();
  var isMapPrepare = true.obs;

  /// 初始移動位置
  double py0 = 0.0;
  double px0 = 0.0;

  /// 主要是Android的大概位置
  /// 先宣告 CameraPosition
  CameraPosition cameraInitPosition = const CameraPosition(
      target: LatLng(
        25.03,
        121.56,
      ),
      zoom: 15);

  /// 先宣告 LocationData
  LocationData locationData = LocationData.fromMap({
    "latitude": 25.03,
    "longitude": 121.56,
  });

  RxSet<CustomMarker> markers = <CustomMarker>{}.obs;
  var isLoading = true.obs;

  var firstLoading = false.obs;
  var dataList = <DataAll>[].obs;

  // 廣告宣告
  BannerAd? bannerAd;
  var isADShowing = false.obs;

  /// 暫存點選到的地標
  final selectedMarker = Rx<CustomMarker?>(null);

  /// 所設定可顯示Marker的距離
  final distanceValue = 10000; // 距離小於等於 10 公里

  /// DB設定
  final DataController dataController = Get.find();

  /// 選單設定
  var selectedItem = '全部'.obs;

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    isMapPrepare(false);

    /// 傳送自定義事件
    analytics.logEvent(name: '查看地圖', parameters: {'status': 'success'});
  }

  void onMarkerTapped(DataAll item) {
    // selectedMarker.value = marker;
    // 處理 Marker 點擊事件

    onTap(item);
  }

  @override
  void onReady() {
    isMapPrepare(true);
    super.onReady();
  }

  @override
  void onInit() async {
    super.onInit();
    adMobBanner();

    /// 取得自己的位置
    await getMyLocation();

    // DB資料判斷
    String updateTime =
        sharedPreferences.getString(AppConstants.homeUpdateShareKey) ?? '';
    if (updateTime != '') {
      DateTime dateTime = DateTime.parse(updateTime);
      DateTime now = DateTime.now();
      // 不需要太常更新1個禮拜一次即可
      DateTime lastWeek = now.subtract(const Duration(days: 7));

      if (dateTime.day >= lastWeek.day) {
        fetchDB();
      } else {
        fetchApi();
      }
    } else {
      /// DB相關
      DataAllDao dataData = await FxDataBaseManager.dataAllDao();

      var count = await dataData.checkTableIsEmpty();
      if (count! > 0) {
        isLoading(true);
        fetchDB();
      } else {
        firstLoading(true);
        fetchApi();
      }
    }
  }

  /// 抓取資料判斷
  void fetchDB() async {
    dataList.assignAll(await dataController.fetchData());

    py0 = locationData.longitude ?? 121.56;
    px0 = locationData.latitude ?? 25.03;

    final newMarkers = dataList.where((e) {
      final distance =
          Geolocator.distanceBetween(e.py ?? 0.0, e.px ?? 0.0, px0!, py0!);
      return distance <= distanceValue;
    }).map((e) {
      return CustomMarker(
        markerId: MarkerId(e.name!),
        position: LatLng(e.py ?? 0.0, e.px ?? 0.0),
        infoWindow: InfoWindow(title: e.name, onTap: () => onMarkerTapped(e)),
        dataAll: e,
        onTap: () => onMarkerTapped(e), // 添加這一行
      );
    });
    markers.addAll(newMarkers);
    firstLoading(false);
    isLoading(false);
  }

  /// 抓取遠端資料
  void fetchApi() async {
    await dataController.fetchRemoteData().then((data) {
      fetchDB();
    });
  }

  Future<void> getMyLocation() async {
    // Get current location
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    cameraInitPosition = CameraPosition(
        target: LatLng(
          locationData?.latitude! ?? 0.0,
          locationData?.longitude! ?? 0.0,
        ),
        zoom: 15);
  }

  /// 設定廣告
  void adMobBanner() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          isADShowing(true);
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            print('Failed to load a banner ad: ${err.message}');
          }
          ad.dispose();
        },
      ),
    ).load();
  }

  /// 進詳細
  void onTap(DataAll item) {
    if (kDebugMode) {
      print(item.name);
    }
    // 儲存資料 - 判斷這個item title有沒有資料
    List<String> historyList =
        (sharedPreferences.getStringList(AppConstants.homeHistory) ??
            <String>[]);
    var match = historyList.firstWhere(
        (element) => element.contains(item.name!),
        orElse: () => '');
    if (match == '') {
      // 確定沒有儲存
      historyList.add(item.name!);
      sharedPreferences.setStringList(AppConstants.homeHistory, historyList);
    }
    // 跳頁
    Get.toNamed(AppRoutes.travelDetails, arguments: item);
  }

  /// 監聽滑動地圖的位置
  Future<void> onCameraMove(CameraPosition position) async {
    // Get the current camera position
    final LatLng latLng = position.target;
    // Do something with the new position
    // ... await location.getLocation();
    py0 = latLng.longitude;
    px0 = latLng.latitude;
  }

  /// 更新附近的Marker
  void updateNearbyMarkers() async {
    final newMarkers = dataList.where((e) {
      final distance =
          Geolocator.distanceBetween(e.py ?? 0.0, e.px ?? 0.0, px0!, py0!);
      if (selectedItem.value == '景點') {
        return distance <= distanceValue &&
            (selectedItem.value == '全部' ||
                !e.name!.contains('公園') && !e.name!.contains('夜市'));
      } else {
        return distance <= distanceValue &&
            (selectedItem.value == '全部' ||
                e.name!.contains(selectedItem.value));
      }
    }).map((e) {
      return CustomMarker(
        markerId: MarkerId(e.name!),
        position: LatLng(e.py ?? 0.0, e.px ?? 0.0),
        infoWindow: InfoWindow(title: e.name, onTap: () => onMarkerTapped(e)),
        dataAll: e,
        onTap: () => onMarkerTapped(e), // 添加這一行
      );
    });
    markers.clear();
    markers.addAll(newMarkers);
  }

  /// 選單選中
  void onItemSelected(String value) {
    selectedItem.value = value;
    updateNearbyMarkers();
  }
}
