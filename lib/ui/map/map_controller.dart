import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../../config/AdHelper.dart';
import '../../data/database/categoryDb.dart';
import '../../data/mode/data_all.dart';
import '../../data/repo/data_repo.dart';

class MapController extends GetxController {
  Completer<GoogleMapController> mapController = Completer();
  late CameraPosition cameraInitPosition;
  late LocationData locationData;
  final Set<Marker> markers = {};
  var isLoading = true.obs;

  var firstLoading = false.obs;
  var dataList = <DataAll>[].obs;
  // 廣告宣告
  BannerAd? bannerAd;
  var isADShowing = false.obs;

  /// DB設定
  CategoryDb categoryDb = CategoryDb();
  final DataController dataController = Get.find();

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
    isLoading(false);
  }

  @override
  void onInit() async {
    super.onInit();
    adMobBanner();

    /// 取得自己的位置
    await getMyLocation();
    await categoryDb.open();
    if (await categoryDb.checkTableIsEmpty() > 0) {
      fetchDB();
    } else {
      firstLoading(true);
      fetchApi();
    }
    categoryDb.close();
  }

  /// 抓取資料判斷
  void fetchDB() async {
    isLoading(true);
    dataList.assignAll(await dataController.fetchData());
    final newMarkers = dataList
        .map((e) => Marker(
              markerId: MarkerId(e.title),
              position:
                  LatLng(double.parse(e.py ?? ''), double.parse(e.px ?? '')),
              infoWindow: InfoWindow(title: e.title),
            ))
        .toSet();
    markers.addAll(newMarkers);
    firstLoading(false);
    isLoading(false);
  }

  /// 抓取遠端資料
  void fetchApi() async {
    isLoading(true);
    await dataController.fetchRemoteData().then((data) {
      dataList.assignAll(data);
      fetchDB();
    });
  }

  Future<void> fetchMarkers() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/qn5566/travel/main/all_data.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      final newMarkers = data
          .map((e) => Marker(
                markerId: MarkerId(e['Title']),
                position: LatLng(double.parse(e['Py']), double.parse(e['Px'])),
                infoWindow: InfoWindow(title: e['Title']),
              ))
          .toSet();

      markers.addAll(newMarkers);
      isLoading(false);
    } else {
      throw Exception('Failed to load markers');
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
}
