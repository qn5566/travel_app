import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marquee/marquee.dart';

import '../../config/style_info.dart';
import '../../util/ui_util.dart';
import '../../widgets/article_widget.dart';
import 'account_controller.dart';

/*
設定頁面
 */
class AccountPage extends GetView<AccountController> {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    String key = '';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'images/setting/background_setting_2.png',
                  fit: BoxFit.fitHeight,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: ScreenUtil().statusBarHeight + 10),
                  Obx(() => (controller.isADShowing.value &&
                      controller.bannerAd != null)
                      ? Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: controller.bannerAd!.size.width.toDouble(),
                      height: controller.bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: controller.bannerAd!),
                    ),
                  )
                      : SizedBox(
                    height: ASize.h(0),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Row(
                      children: [
                        Text("暱稱:",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: ASize.ft(8),
                            )),
                        Obx(() => (controller.username.value == '')
                            ? Expanded(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SizedBox(
                                  width: ASize.w(100),
                                  child: CupertinoTextField(
                                    textAlign: TextAlign.center,
                                    controller:
                                    controller.textEditingController,
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    maxLength: 10,
                                    placeholder: "請輸入暱稱",
                                    placeholderStyle: TextStyle(
                                        fontSize: ASize.ft(8),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                    decoration:
                                    // const BoxDecoration(color: Colors.transparent),
                                    BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(
                                                ASize.w(18))),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white),
                                    onChanged: (value) {
                                      if (kDebugMode) {
                                        print(value);
                                      }
                                      key = value;
                                    },
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: ASize.w(2),
                                  ),
                                  child: Container(
                                    height: ASize.h(16),
                                    width: ASize.w(30),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(ASize.w(30))),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text("確認",
                                          style: TextStyle(
                                              color: (key.isNotEmpty)
                                                  ? Colors.black
                                                  : StyleInfo.gray_7C7C8D,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "PingFang-SC",
                                              fontStyle: FontStyle.normal,
                                              fontSize: ASize.ft(7))),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if (key.isNotEmpty) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    controller.updateUsername(key);

                                    controller.username.value = key;
                                  }
                                },
                              )
                            ],
                          ),
                        )
                            : Expanded(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(controller.username.value,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "PingFangSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: ASize.ft(8),
                                    )),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: ASize.w(2),
                                  ),
                                  child: Container(
                                    height: ASize.h(16),
                                    width: ASize.w(30),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(ASize.w(30))),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text("替換",
                                          style: TextStyle(
                                              color:
                                              StyleInfo.gray_7C7C8D,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "PingFang-SC",
                                              fontStyle: FontStyle.normal,
                                              fontSize: ASize.ft(7))),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  controller.changeUsername();
                                  controller.username.value = '';
                                  key = '';
                                },
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: ASize.h(10)),
                  SizedBox(
                    width: 500,
                    height: 30,
                    child: Marquee(
                      text: controller.userData.option.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      blankSpace: 20,
                      velocity: 50,
                      pauseAfterRound: const Duration(seconds: 5),
                      startPadding: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                  SizedBox(height: ASize.h(10)),
                  ArticleWidget(
                      title: controller.userData.infoMenu[0],
                      subtitle: controller.userData.infoMenu[1],
                      content: controller.userData.infoMenu[2]),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      '資料來源',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const Text('政府資料開放平臺',
                        style: TextStyle(color: Colors.black)),
                    const Text('pexels.com',
                        style: TextStyle(color: Colors.black)),
                    SizedBox(height: ASize.h(2)),
                    const Text(
                      '特別感謝',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const Text('MeetStudio 工作社',
                        style: TextStyle(color: Colors.black)),
                    Text('版本:${controller.getAppVersion()}',
                        style: const TextStyle(color: Colors.black)),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
