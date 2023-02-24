import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/util/ui_util.dart';

import 'map_controller.dart';

class MapPage extends GetView<MapController> {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Obx(() => controller.firstLoading.value
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/car.json'),
                      const Text(
                        '第一次下載會比較久請稍等..',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                : controller.isLoading.value
                    ? Lottie.asset('assets/loading.json')
                    : GoogleMap(
                        onMapCreated: controller.onMapCreated,
                        initialCameraPosition: controller.cameraInitPosition,
                        markers: controller.markers.map((marker) {
                          return marker.copyWith(
                            onTapParam: () => controller.selectedMarker.value =
                                marker, // 設置當前選中的標記
                          );
                        }).toSet(),
                        onTap: (LatLng latLng) {
                          controller.selectedMarker.value = null;
                        },

                        // onMarkerTapped: controller.onMarkerTapped,
                      )),
            Obx(() => controller.isLoading.value
                ? const SizedBox(
                    width: 0,
                  )
                : Positioned(
                    bottom: 16,
                    left: 16,
                    child: IconButton(
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
                      icon: const CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          CupertinoIcons.location,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
            Obx(() =>
                (controller.isADShowing.value && controller.bannerAd != null)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: controller.bannerAd!.size.width.toDouble(),
                            height: controller.bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: controller.bannerAd!),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 1,
                      )),
            Obx(() => controller.selectedMarker.value != null
                ? Positioned(
                    bottom: ASize.h(30),
                    left: ASize.w(30),
                    right: ASize.w(30),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.onTap(
                                    controller.selectedMarker.value!.dataAll);
                              },
                              child: Text(controller
                                  .selectedMarker.value!.markerId.value),
                            ),
                            controller.selectedMarker.value!.dataAll.address !=
                                    null
                                ? GestureDetector(
                                    onTap: () {
                                      controller.onTap(controller
                                          .selectedMarker.value!.dataAll);
                                    },
                                    child: Text(
                                      controller.selectedMarker.value!.dataAll
                                              .address ??
                                          '',
                                      maxLines: 1,
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                  ),
                            GestureDetector(
                              onTap: () {
                                controller.onTap(
                                    controller.selectedMarker.value!.dataAll);
                              },
                              child: const Text('查看更多'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 1,
                  ))
          ],
        ),
      ),
    );
  }
}
