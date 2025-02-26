import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/ui/account/PopViewSettingPage.dart';

import '../../config/style_info.dart';
import '../../util/ad_manager_util.dart';
import '../../util/ui_util.dart';
import 'account_controller.dart';

/*
設定頁面
 */
class AccountPage extends GetView<AccountController> {
  const AccountPage({super.key});

  static TextStyle titleName = TextStyle(
    color: StyleInfo.settingTextColor,
    fontWeight: FontWeight.normal,
    fontFamily: "PingFangSC",
    fontStyle: FontStyle.normal,
    fontSize: ASize.ft(8),
  );

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
                              child: AdManagerUtil().bannerAdWidget(),
                            ),
                          )
                        : SizedBox(
                            height: ASize.h(0),
                          )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Obx(() => (controller.username.value == '')
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: Text("暱稱:", style: titleName),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: SizedBox(
                                    width: ASize.w(80),
                                    child: CupertinoTextField(
                                      textAlign: TextAlign.center,
                                      controller:
                                          controller.textEditingController,
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      maxLength: 10,
                                      placeholder: "請輸入暱稱",
                                      placeholderStyle: titleName,
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
                                    padding: EdgeInsets.only(right: ASize.w(2)),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: ASize.w(5)),
                                      height: ASize.h(16),
                                      decoration: BoxDecoration(
                                        color: StyleInfo.settingButtonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(ASize.w(30))),
                                      ),
                                      child: Center(
                                        child: Text("確認",
                                            style: TextStyle(
                                                color: (key.isNotEmpty)
                                                    ? StyleInfo.settingTextColor
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
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: Text("暱稱:", style: titleName),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
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
                                    padding: EdgeInsets.only(right: ASize.w(2)),
                                    child: Container(
                                      height: ASize.h(14),
                                      width: ASize.w(28),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(ASize.w(30))),
                                        color: StyleInfo.settingButtonColor,
                                      ),
                                      child: Center(
                                        child: Text("替換", style: titleName),
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
                            )),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                                  PopViewSettingPage(controller: controller),
                            );
                          },
                        );
                      },
                      child: const Text('顯示更多資訊'),
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
