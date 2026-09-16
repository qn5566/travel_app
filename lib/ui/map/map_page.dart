import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/util/ad_manager_util.dart';
import 'package:travel/widgets/tech_download_progress.dart';
import 'package:travel/widgets/tech_map_controls.dart';
import 'package:travel/widgets/tech_travel_background.dart';

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
                    const Positioned.fill(
                      child: TechTravelBackground(),
                    ),
                    TechDownloadProgress(
                      progress: controller.progress.value,
                      status: controller.downloadStatus.value,
                      showRetry: controller.showRefresh.value,
                      onRetry: () {
                        controller.showRefresh.value = false;
                        controller.fetchApi();
                      },
                    ),
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
            Obx(() => controller.isMapPrepare.value
                ? const SizedBox.shrink()
                : TechMapControls(
                    categories: items,
                    selectedCategory: controller.selectedItem.value,
                    markerCount: controller.markers.length,
                    onCategorySelected: controller.onItemSelected,
                    onLocate: () async {
                      final mapController =
                          await controller.mapController.future;
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(
                              controller.locationData.latitude ?? 25.03,
                              controller.locationData.longitude ?? 121.56,
                            ),
                            zoom: 15,
                          ),
                        ),
                      );
                    },
                    onRefresh: controller.updateNearbyMarkers,
                    bannerAdWidget: controller.isADShowing.value &&
                            controller.bannerAd != null
                        ? SizedBox(
                            width: controller.bannerAd!.size.width.toDouble(),
                            height:
                                controller.bannerAd!.size.height.toDouble(),
                            child: AdManagerUtil()
                                .bannerAdWidget(controller.bannerAd!),
                          )
                        : null,
                  )),
            Obx(() => controller.isMapPrepare.value &&
                    !controller.firstLoading.value
                ? Stack(
                    children: [
                      const Positioned.fill(
                        child: TechTravelBackground(),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x99040D1D),
                              Color(0xD9050B1A),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Lottie.asset('assets/map_loading.json'),
                      ),
                    ],
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
