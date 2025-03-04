import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/mode/data_all.dart';

class CustomMarker extends Marker {
  final DataAll dataAll;
  final void Function() onTap; // 添加 onTap 屬性

  const CustomMarker({
    required MarkerId markerId,
    required LatLng position,
    required InfoWindow infoWindow,
    required Offset anchor,
    required this.dataAll,
    required this.onTap, // 接收 onTap 屬性
  }) : super(
          markerId: markerId,
          position: position,
          infoWindow: infoWindow,
          anchor: anchor,
        );
}
