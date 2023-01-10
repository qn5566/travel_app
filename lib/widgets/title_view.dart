import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/ui_util.dart';

class TitleView extends StatefulWidget {
  final Key key;
  final String title;
  final bool isShowTitle;

  const TitleView(
      {required this.key, required this.title, this.isShowTitle = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TitleViewState();
  }
}

class TitleViewState extends State<TitleView> {
  bool isShow = false;

  @override
  void initState() {
    super.initState();
    isShow = widget.isShowTitle;
  }

  @override
  Widget build(BuildContext context) {
    return isShow
        ? Text(widget.title ?? '',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: "PingFangSC",
                fontStyle: FontStyle.normal,
                fontSize: ASize.ft(17)),
            textAlign: TextAlign.center)
        : const SizedBox.shrink();
  }

  void setIsShowTitle(bool isShow) {
    if (this.isShow != isShow) {
      this.isShow = isShow;
      setState(() {});
    }
  }
}
