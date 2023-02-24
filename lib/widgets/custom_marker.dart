import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/mode/data_all.dart';

class CustomMarker extends Marker {
  final DataAll dataAll;

  const CustomMarker(
      {required super.markerId,
      required super.position,
      required super.infoWindow,
      required this.dataAll})
      : super();
}
