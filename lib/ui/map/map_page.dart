import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/config/style_info.dart';
import 'package:travel/util/ad_manager_util.dart';
import 'package:travel/util/ui_util.dart';

import 'map_controller.dart';

class MapPage extends GetView<MapController> {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> items = ["全部", "景點", "公園", "夜市"];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Obx(() => controller.firstLoading.value
                ? Stack(children: [
                    Positioned.fill(
                      child: Image.asset(
                        'images/home/home_bg.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 毛玻璃效果 - 半透明
                    Container(
                      color: const Color(0xFF0E3311).withOpacity(0.5),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Lottie.asset('assets/car.json')),
                        const Text(
                          '第一次下載會比較久請稍等..',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  ])
                : controller.isLoading.value
                    ? const SizedBox(
                        height: 0,
                      )
                    : GoogleMap(
                        onMapCreated: controller.onMapCreated,
                        initialCameraPosition: controller.cameraInitPosition,
                        markers: controller.markers.map((marker) {
                          return marker.copyWith(
                            onTapParam: () => controller.selectedMarker.value =
                                marker, // 設置當前選中的標記
                          );
                        }).toSet(),
                        onCameraMove: (position) {
                          controller.onCameraMove(position);
                        },
                        onTap: (LatLng latLng) {
                          controller.selectedMarker.value = null;
                        },
                      )),
            Obx(
              () => controller.isMapPrepare.value
                  ? const SizedBox(
                      width: 0,
                    )
                  : Positioned(
                      bottom: ASize.h(5),
                      left: ASize.w(5),
                      child: FloatingActionButton(
                        onPressed: () async {
                          final mapController =
                              await controller.mapController.future;
                          mapController
                              .animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                controller.locationData.latitude!,
                                controller.locationData.longitude!,
                              ),
                              zoom: 15,
                            ),
                          ));
                        },
                        backgroundColor: Colors.white,
                        child: const Icon(
                          CupertinoIcons.location,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
            Obx(() => controller.isMapPrepare.value
                ? const SizedBox(
                    width: 0,
                  )
                : Positioned(
                    bottom: ASize.h(5),
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFE60012),
                            // 文字顏色為白色
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            // 設定按鈕的 padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // 設定按鈕圓角
                            ),
                          ),
                          onPressed: () {
                            controller.updateNearbyMarkers();
                          },
                          child: const Text(
                            '更新附近資料',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )),
            Obx(() =>
                (controller.isADShowing.value && controller.bannerAd != null)
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: ASize.h(20),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: controller.bannerAd!.size.width.toDouble(),
                            height: controller.bannerAd!.size.height.toDouble(),
                            child: AdManagerUtil().bannerAdWidget(),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 1,
                      )),
            Obx(() => controller.isMapPrepare.value &&
                    controller.firstLoading.value != true
                ? Stack(children: [
                    Positioned.fill(
                      child: Image.asset(
                        'images/home/home_bg.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 毛玻璃效果 - 半透明
                    Container(
                      color: const Color(0xFF0E3311).withOpacity(0.5),
                    ),
                    Center(child: Lottie.asset('assets/loading.json')),
                  ])
                : const SizedBox(
                    height: 0,
                  )),
            Obx(() => controller.isMapPrepare.value
                ? const SizedBox(
                    width: 0,
                  )
                : Positioned(
                    top: ASize.h(50),
                    left: ASize.w(5),
                    child: Container(
                      margin: EdgeInsets.only(
                          left: ASize.w(10), right: ASize.w(10)),
                      child: Wrap(
                        spacing: ASize.w(10),
                        runSpacing: ASize.w(10),
                        children: items.map(
                          (e) {
                            bool isSelected =
                                controller.selectedItem.value == e;
                            Color backgroundColor;
                            if (e == '景點') {
                              backgroundColor = StyleInfo.searchTextTagTwo;
                            } else if (e == '公園') {
                              backgroundColor = StyleInfo.searchTextTagOne;
                            } else if (e == '夜市') {
                              backgroundColor = StyleInfo.searchTextHomeHitTwo;
                            } else {
                              backgroundColor = StyleInfo.searchTextResHitOne;
                            }
                            return GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(ASize.w(50)),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: ASize.w(8),
                                    right: ASize.w(8),
                                    top: ASize.w(2.5),
                                    bottom: ASize.w(2.5),
                                  ),
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                        fontSize: ASize.ft(6),
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              onTap: () {
                                controller.selectedItem.value = e;
                                controller.onItemSelected(e);
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
