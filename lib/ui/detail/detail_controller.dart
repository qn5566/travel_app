import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/ui_util.dart';
import '../../widgets/title_view.dart';

class DetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var counter = 0.obs;
  late TabController tabInfoController;
  late ScrollController scrollController;
  bool isShowTitle = false;
  GlobalKey<TitleViewState> titleStateKey = GlobalKey();

  /// 子分類
  final List<Tab> subTitle = const <Tab>[
    Tab(text: '資訊'),
    Tab(text: '評論'),
  ];

  @override
  void onInit() {
    super.onInit();
    tabInfoController = TabController(length: subTitle.length, vsync: this);
    scrollController = ScrollController()
      ..addListener(() {
        bool isShow = scrollController.offset >= ASize.w(120);
        if (isShowTitle != isShow) {
          isShowTitle = isShow;
          titleStateKey.currentState?.setIsShowTitle(isShowTitle);
        }
      });
  }

  @override
  void onClose() {
    tabInfoController.dispose();
    super.onClose();
  }

  void increaseCounter() {
    counter.value += 1;
  }
}
