import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marquee/marquee.dart';

import '../../config/style_info.dart';
import '../../util/ui_util.dart';
import '../../widgets/ClickableImage.dart';
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
          body: SingleChildScrollView(
            child: Stack(
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
                              height:
                                  controller.bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: controller.bannerAd!),
                            ),
                          )
                        : SizedBox(
                            height: ASize.h(0),
                          )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 5),
                      child: Row(
                        children: [
                          Text("暱稱:",
                              style: TextStyle(
                                color: StyleInfo.settingTextColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: ASize.ft(8),
                              )),
                          Obx(() => (controller.username.value == '')
                              ? Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: SizedBox(
                                          width: ASize.w(80),
                                          child: CupertinoTextField(
                                            textAlign: TextAlign.center,
                                            controller: controller
                                                .textEditingController,
                                            keyboardType: TextInputType.text,
                                            maxLines: 1,
                                            maxLength: 10,
                                            placeholder: "請輸入暱稱",
                                            placeholderStyle: TextStyle(
                                                fontSize: ASize.ft(8),
                                                fontWeight: FontWeight.normal,
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: ASize.w(5)),
                                            height: ASize.h(16),
                                            decoration: BoxDecoration(
                                              color:
                                                  StyleInfo.settingButtonColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ASize.w(30))),
                                            ),
                                            child: Center(
                                              child: Text("確認",
                                                  style: TextStyle(
                                                      color: (key.isNotEmpty)
                                                          ? StyleInfo
                                                              .settingTextColor
                                                          : StyleInfo
                                                              .gray_7C7C8D,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: "PingFang-SC",
                                                      fontStyle:
                                                          FontStyle.normal,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Text(controller.username.value,
                                            style: TextStyle(
                                              color: StyleInfo.settingTextColor,
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ASize.w(30))),
                                              color:
                                                  StyleInfo.settingButtonColor,
                                            ),
                                            child: Center(
                                              child: Text("替換",
                                                  style: TextStyle(
                                                      color:
                                                          StyleInfo.gray_7C7C8D,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: "PingFang-SC",
                                                      fontStyle:
                                                          FontStyle.normal,
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
                    const Text(
                      '台灣吃喝玩樂地圖APP',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: StyleInfo.assistColor),
                    ),
                    SizedBox(height: ASize.h(2)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'images/setting/setting_banner.jpg',
                        fit: BoxFit.contain,
                        height: 150,
                        alignment: Alignment.center,
                      ),
                    ),
                    SizedBox(height: ASize.h(8)),
                    const Text(
                      '查詢附近美食周邊景點和親子公園\n還可以查音樂祭和附近活動或是煙火\n'
                      'Inquire about nearby food, surrounding\n attractions and parent-child parks\n'
                      'You can also check music festivals and nearby\n events or fireworks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: StyleInfo.infoTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: ASize.h(8)),
                    SizedBox(
                      height: ASize.h(60),
                      width: ASize.w(60),
                      child: ClickableImage(
                        imageUrl: 'images/icon/event_icon_512.png',
                        androidUrl:
                            'https://play.google.com/store/apps/details?id=com.meetstudio.event',
                        iosUrl:
                            'https://apps.apple.com/us/app/%E5%8F%B0%E7%81%A3%E5%90%83%E5%96%9D%E7%8E%A9%E6%A8%82%E5%9C%B0%E5%9C%96/id6446348643',
                      ),
                    ),
                    SizedBox(height: ASize.h(4)),
                    const Text(
                      '歡迎下載台灣吃喝玩樂地圖ＡＰＰ',
                      style: TextStyle(
                          color: StyleInfo.assistColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 8, bottom: 8),
                      child: Divider(
                        color: StyleInfo.separatorSettingColor,
                        thickness: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              '資料來源',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text('政府資料開放平臺',
                                style: TextStyle(color: Colors.black)),
                            Text('pexels.com',
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                        SizedBox(width: ASize.w(10)),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 8),
                          child: Divider(
                            color: StyleInfo.separatorSettingColor,
                            thickness: 1,
                          ),
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                '特別感謝',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('MeetStudio 工作社',
                                  style: TextStyle(color: Colors.black)),
                              Text('版本:${controller.getAppVersion()}',
                                  style: const TextStyle(color: Colors.black)),
                              Text('BuildNumber:${controller.getAppBuildNumber()}',
                                  style: const TextStyle(color: Colors.black)),
                            ])
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
