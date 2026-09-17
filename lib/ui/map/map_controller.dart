import 'dart:async';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:location/location.dart';
import 'package:travel/config/AdHelper.dart';
import 'package:travel/util/ad_manager_util.dart';

import '../../config/global_config.dart';
import '../../config/rx_config.dart';
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

  /// 對話筐狀態
  var alertDialogShow = true.obs;

  /// 對話筐狀態
  var showRefresh = false.obs;

  /// 下載狀態
  var downloadStatus = '第一次下載會比較久請稍等..'.obs;

  /// 下載進度
  var progress = 0.0.obs;

  var dataList = <DataAll>[].obs;

  // 廣告宣告
  BannerAd? bannerAd;
  var isADShowing = false.obs;

  /// 暫存點選到的地標
  final selectedMarker = Rx<CustomMarker?>(null);

  /// 所設定可顯示Marker的距離
  final distanceValue = 10000; // 距離小於等於 10 公里

  /// Limits native Google Maps marker work during initial rendering.
  static const maxVisibleMarkers = 120;

  /// DB設定
  final DataController dataController = Get.find();
  final RxConfig userData = Get.find();
  Worker? _dataVersionWorker;
  Timer? _markerUpdateTimer;

  /// 選單設定
  var selectedItem = '全部'.obs;

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    isMapPrepare(false);

    /// 載入廣告（延遲到地圖建立後，避免同時初始化太多 PlatformView）
    adMobBanner();

    /// 傳送自定義事件
    try {
      analytics.logEvent(name: '查看地圖', parameters: {'status': 'success'});
    } catch (_) {}
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
  void onInit() {
    super.onInit();
    _dataVersionWorker = ever<int>(userData.dataVersion, (_) {
      final storedVersion =
          sharedPreferences.getInt(AppConstants.homeDataVersionKey) ?? 0;
      if (userData.dataVersion.value > storedVersion && !firstLoading.value) {
        fetchApi();
      }
    });
    toDownload();
    _initializeLocation();
  }

  @override
  void dispose() {
    _dataVersionWorker?.dispose();
    _markerUpdateTimer?.cancel();
    mapController = Completer();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    await getMyLocation();
    if (dataList.isNotEmpty) updateNearbyMarkers();
  }

  /// 執行資料下載
  void toDownload() async {
    /// DB資料判斷
    final storedDataVersion =
        sharedPreferences.getInt(AppConstants.homeDataVersionKey) ?? 0;
    if (storedDataVersion < userData.dataVersion.value) {
      // The v2 ZIP parser is not compatible with rows created by the old
      // endpoint. Always rebuild the local snapshot once after an upgrade.
      firstLoading(true);
      await fetchApi();
      return;
    }

    // A database migration can legitimately leave the table empty even when
    // the old update timestamp is still present. Never treat an empty table
    // as a valid cached snapshot.
    final dataDao = await FxDataBaseManager.dataAllDao();
    final recordCount = await dataDao.checkTableIsEmpty() ?? 0;
    if (recordCount == 0) {
      firstLoading(true);
      await fetchApi();
      return;
    }

    String updateTime =
        sharedPreferences.getString(AppConstants.homeUpdateShareKey) ?? '';
    if (updateTime != '') {
      // 資料新舊改由 DashboardController 的「兩週更新提醒」彈窗負責，
      // 地圖頁一律讀本地；版本落後 / DB 空的重抓已在前段處理。
      fetchDB();
    } else {
      /// DB相關
      DataAllDao dataData = await FxDataBaseManager.dataAllDao();

      final count = await dataData.checkTableIsEmpty() ?? 0;
      if (count > 0) {
        isLoading(true);
        fetchDB();
      } else {
        firstLoading(true);
        fetchApi();
      }
    }
  }

  /// 抓取資料判斷
  Future<void> fetchDB() async {
    try {
      dataList.assignAll(await dataController.fetchData());
      py0 = locationData.longitude ?? 121.56;
      px0 = locationData.latitude ?? 25.03;
      updateNearbyMarkers();
      firstLoading(false);
      isLoading(false);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }

      markers.clear();
      isLoading(false);
    }
  }

  /// 抓取遠端資料
  Future<void> fetchApi() async {
    firstLoading(true);
    showRefresh(false);
    progress.value = 0.1;
    downloadStatus.value = '正在下載景點資料…';
    // Keep the UI moving even when another controller already owns the shared
    // download future (in that case no progress callback is available here).
    final progressTicker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (progress.value < 0.8) {
        progress.value = (progress.value + 0.01).clamp(0.1, 0.8).toDouble();
      }
    });
    try {
      await dataController.fetchRemoteData(onProgress: (value) {
        // Keep the progress bar below 90% while the ZIP is being downloaded
        // and parsed. The remaining 10% is reserved for SQLite creation.
        progress.value = value.clamp(0.1, 0.9).toDouble();
      });
      downloadStatus.value = '正在建立離線資料…';
      await fetchDB();
      progress.value = 1;
    } catch (e) {
      downloadStatus.value = '下載失敗，請檢查網路後重試';
      showRefresh(true);
      if (kDebugMode) print('Error fetching remote data: $e');
    } finally {
      progressTicker.cancel();
    }
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
          locationData.latitude ?? 25.03,
          locationData.longitude ?? 121.56,
        ),
        zoom: 15);
  }

  /// 設定廣告
  void adMobBanner() {
    const placementId = 'map-banner';
    AdManagerUtil.initializeAd(
      AdHelper.mapAdUnitId,
      placementId: placementId,
    );
    bannerAd = AdManagerUtil.bannerAd(
      AdHelper.mapAdUnitId,
      placementId: placementId,
    );
    isADShowing = AdManagerUtil.isADShowing(
      AdHelper.mapAdUnitId,
      placementId: placementId,
    );
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
    Get.toNamed(AppRoutes.travelDetails, arguments: {
      'item': item,
      'page': 'map',
    });
  }

  /// 監聽滑動地圖的位置
  Future<void> onCameraMove(CameraPosition position) async {
    // Get the current camera position
    final LatLng latLng = position.target;
    // Do something with the new position
    // ... await location.getLocation();
    py0 = latLng.longitude;
    px0 = latLng.latitude;

    // Debounce marker updates so panning/zooming doesn't trigger the
    // expensive O(n) scan on every frame.
    _markerUpdateTimer?.cancel();
    _markerUpdateTimer = Timer(const Duration(milliseconds: 500), () {
      updateNearbyMarkers();
    });
  }

  /// 更新附近的Marker
  void updateNearbyMarkers() async {
    final newMarkers = <CustomMarker>[];
    var matchedMarkerCount = 0;
    for (final e in dataList) {
      final coordinate = _coordinateFor(e);
      if (coordinate == null) continue;

      final distance = Geolocator.distanceBetween(
        coordinate.latitude,
        coordinate.longitude,
        px0,
        py0,
      );
      if (distance > distanceValue) continue;

      final name = e.name?.trim();
      if (name == null || name.isEmpty) continue;
      final selectedCategory = selectedItem.value;
      final isCategoryMatch = selectedCategory == '全部'
          ? true
          : selectedCategory == '景點'
              ? !name.contains('公園') && !name.contains('夜市')
              : name.contains(selectedCategory);
      if (!isCategoryMatch) continue;

      matchedMarkerCount++;
      if (newMarkers.length >= maxVisibleMarkers) continue;
      newMarkers.add(CustomMarker(
        // AttractionID is unique; names are not guaranteed to be unique.
        markerId: MarkerId(e.id ?? name),
        position: LatLng(coordinate.latitude, coordinate.longitude),
        anchor: const Offset(0.5, 0.5),
        infoWindow: InfoWindow(title: name, onTap: () => onMarkerTapped(e)),
        dataAll: e,
        onTap: () => onMarkerTapped(e),
      ));
    }
    markers.assignAll(newMarkers);
    if (kDebugMode) {
      print(
        'Map markers: total=${dataList.length}, matched=$matchedMarkerCount, '
        'rendered=${newMarkers.length}/$maxVisibleMarkers, '
        'center=($px0,$py0), radius=${distanceValue}m',
      );
    }
  }

  /// Returns latitude/longitude in the order required by Google Maps.
  ///
  /// Records downloaded by an older build stored Px/Py in reverse order.
  /// Keep accepting those cached records so an app upgrade does not leave a
  /// blank map until the next full download.
  _MapCoordinate? _coordinateFor(DataAll item) {
    final first = item.py;
    final second = item.px;
    if (first == null || second == null ||
        !first.isFinite || !second.isFinite) {
      return null;
    }

    var latitude = first;
    var longitude = second;
    if (first.abs() > 90 && second.abs() <= 90) {
      latitude = second;
      longitude = first;
    }
    if (latitude < -90 || latitude > 90 ||
        longitude < -180 || longitude > 180) {
      return null;
    }
    return _MapCoordinate(latitude, longitude);
  }

  /// 選單選中
  void onItemSelected(String value) {
    selectedItem.value = value;
    updateNearbyMarkers();
  }
}

class _MapCoordinate {
  const _MapCoordinate(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}
