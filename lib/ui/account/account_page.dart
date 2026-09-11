import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/ui/account/pop_view_setting_page.dart';

import '../../config/style_info.dart';
import '../../util/ad_manager_util.dart';
import '../../util/ui_util.dart';
import '../../widgets/comment_view_message_board.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(children: [
          Positioned.fill(
            child: Image.asset(
              'images/setting/background_setting_2.webp',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
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
                          child: AdManagerUtil()
                              .bannerAdWidget(controller.bannerAd!),
                        ),
                      )
                    : SizedBox(height: ASize.h(0))),
                SizedBox(height: ASize.h(5)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() => (controller.username.value == '')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 242, 242, 247),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: CupertinoColors.systemGrey4
                                                .withOpacity(0.5),
                                            blurRadius: 5.0,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      maxLines: 1,
                                      maxLength: 10,
                                      placeholder: "請輸入暱稱",
                                      placeholderStyle: titleName,
                                      onChanged: (value) {
                                        if (kDebugMode) {
                                          print(value);
                                        }
                                        controller.draftUsername.value = value;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ASize.w(5)),
                                height: ASize.h(16),
                                decoration: BoxDecoration(
                                  color: StyleInfo.settingButtonColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text("確認",
                                      style: TextStyle(
                                          color: (controller.draftUsername.value
                                                  .isNotEmpty)
                                              ? StyleInfo.settingTextColor
                                              : StyleInfo.black_1D1D28,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "PingFang-SC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: ASize.ft(7))),
                                ),
                              ),
                              onTap: () {
                                if (controller.draftUsername.value.isNotEmpty) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  controller.updateUsername(
                                      controller.draftUsername.value);
                                  controller.username.value =
                                      controller.draftUsername.value;
                                }
                              },
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
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
                              ],
                            ),
                            GestureDetector(
                              child: Container(
                                height: ASize.h(14),
                                width: ASize.w(28),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: StyleInfo.settingButtonColor,
                                ),
                                child: Center(
                                  child: Text("替換", style: titleName),
                                ),
                              ),
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                controller.changeUsername();
                                controller.username.value = '';
                                controller.draftUsername.value = '';
                              },
                            ),
                          ],
                        )),
                ),
                CommentViewMessageBoard(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white, // 設定底色為白色
                        content: PopViewSettingPage(controller: controller),
                      );
                    },
                  );
                },
                child:
                    const Text('更多資訊', style: TextStyle(color: Colors.purple)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
              child: InkWell(
                onTap: () async {
                  controller.startAnimation();
                  await controller.fetchApi();
                  controller.stopAnimation();
                },
                child: Container(
                  width: ASize.w(16),
                  height: ASize.h(16),
                  decoration: BoxDecoration(
                    color: StyleInfo.settingButtonColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: AnimatedBuilder(
                    animation: controller.animationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: controller.animationController.value *
                            2.0 *
                            3.1415927,
                        child: const Icon(Icons.refresh,
                            color: StyleInfo.settingTextColor),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey, width: 1.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: CupertinoTextField(
                          textAlign: TextAlign.start,
                          controller: controller.messageController,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          maxLength: 30,
                          placeholder: "留下你的心得吧!",
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onChanged: (value) {
                            // The controller owns the text field state.
                          },
                        ),
                      ),
                    ),
                    FloatingActionButton.small(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        controller.checkSendData(
                            context, controller.messageController.text,
                            callback: (value) {
                          if (value == 'ok') {
                            controller.fetchApi();
                            controller.messageController.clear();
                          }
                        });
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
