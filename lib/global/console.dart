import 'package:flutter/foundation.dart';

void logPrint(Object? object) {
  assert(() {
    if (kDebugMode) {
      debugPrint(object.toString());
    }
    return true;
  }());
}
