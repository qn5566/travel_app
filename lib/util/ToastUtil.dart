import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class ToastUtil {
  static info(BuildContext context, String msg) {
    ToastContext().init(context);
    Toast.show(msg, duration: Toast.lengthLong, gravity: Toast.bottom);
  }
}
