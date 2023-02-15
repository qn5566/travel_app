import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../config/style_info.dart';
import '../../util/ui_util.dart';
import '../../widgets/list_view_history.dart';
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
                    fit: BoxFit.fitWidth,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Positioned.fill(
                  child: Image.asset(
                    'images/setting/background_setting.png',
                    fit: BoxFit.fitWidth,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5.0),
                    Padding(
                      //标题栏
                      padding:
                          EdgeInsets.only(top: ScreenUtil().statusBarHeight),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('設定',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: ASize.ft(8),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
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
                          const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Row(
                        children: [
                          Text("暱稱:",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
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
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: SizedBox(
                                          width: ASize.w(100),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(controller.username.value,
                                            style: TextStyle(
                                              color: Colors.white,
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
                    SizedBox(height: ASize.h(2)),
                    Text("最近查看",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: ASize.ft(8),
                        )),
                    const SizedBox(height: 5.0),
                    Expanded(child: ListViewHistory()),
                  ],
                ),
              ],
            ),
            floatingActionButton: Obx(() => (controller.dataList.isNotEmpty)
                ? FloatingActionButton.extended(
                    onPressed: () {
                      controller.deleteData();
                    },
                    backgroundColor: Colors.red,
                    label: const Text(
                      '刪除全部資料',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SizedBox(
                    width: ASize.w(1),
                  )));
      }),
    );
  }
}
