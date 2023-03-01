import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:location/location.dart';

import '../../config/AdHelper.dart';
import '../../config/global_config.dart';
import '../../data/database/categoryDb.dart';
import '../../data/mode/data_all.dart';
import '../../data/repo/data_repo.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_marker.dart';

class MapController extends GetxController {
  Completer<GoogleMapController> mapController = Completer();
  late CameraPosition cameraInitPosition;
  var isMapPrepare = true.obs;
  late LocationData locationData;
  final Set<CustomMarker> markers = {};
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
  CategoryDb categoryDb = CategoryDb();
  final DataController dataController = Get.find();

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    isMapPrepare(false);
  }

  void onMarkerTapped(CustomMarker marker) {
    selectedMarker.value = marker;
    // 處理 Marker 點擊事件
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
    await categoryDb.open();
    if (await categoryDb.checkTableIsEmpty() > 0) {
      isLoading(true);
      fetchDB();
    } else {
      firstLoading(true);
      fetchApi();
    }
    categoryDb.close();
  }

  /// 抓取資料判斷
  void fetchDB() async {
    dataList.assignAll(await dataController.fetchData());

    final py0 = locationData.longitude;
    final px0 = locationData.latitude;
    final newMarkers = dataList.where((e) {
      final distance = Geolocator.distanceBetween(
          double.parse(e.py ?? ''), double.parse(e.px ?? ''), px0!, py0!);
      return distance <= distanceValue;
    }).map((e) {
      return CustomMarker(
        markerId: MarkerId(e.title),
        position: LatLng(double.parse(e.py ?? ''), double.parse(e.px ?? '')),
        infoWindow: InfoWindow(title: e.title),
        dataAll: e,
      );
    });
    markers.addAll(newMarkers);
    firstLoading(false);
    isLoading(false);
  }

  /// 抓取遠端資料
  void fetchApi() async {
    await dataController.fetchRemoteData().then((data) {
      dataList.assignAll(data);
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
      print(item.title);
    }
    // 儲存資料 - 判斷這個item title有沒有資料
    List<String> historyList =
        (sharedPreferences.getStringList('history') ?? <String>[]);
    var match = historyList.firstWhere(
        (element) => element.contains(item.title),
        orElse: () => '');
    if (match == '') {
      // 確定沒有儲存
      historyList.add(item.title);
      sharedPreferences.setStringList('history', historyList);
    }
    // 跳頁
    Get.toNamed(AppRoutes.travelDetails, arguments: item);
  }

  /// 更新附近的Marker
  void updateNearbyMarkers() async {
    final py0 = locationData.longitude;
    final px0 = locationData.latitude;
    final newMarkers = dataList.where((e) {
      final distance = Geolocator.distanceBetween(
          double.parse(e.py ?? ''), double.parse(e.px ?? ''), px0!, py0!);
      return distance <= distanceValue;
    }).map((e) {
      return CustomMarker(
        markerId: MarkerId(e.title),
        position: LatLng(double.parse(e.py ?? ''), double.parse(e.px ?? '')),
        infoWindow: InfoWindow(title: e.title),
        dataAll: e,
      );
    });
    markers.clear();
    markers.addAll(newMarkers);
    update();
  }
}
