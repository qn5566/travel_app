import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/ui/account/pop_view_setting_page.dart';

import '../../util/ad_manager_util.dart';
import '../../util/ui_util.dart';
import '../../widgets/comment_view_message_board.dart';
import '../../widgets/tech_detail_widgets.dart';
import '../../widgets/tech_travel_background.dart';
import 'account_controller.dart';

/*
設定頁面
 */
class AccountPage extends GetView<AccountController> {
  const AccountPage({super.key});

  static TextStyle titleName = TextStyle(
    color: const Color(0xFF8CF3FF),
    fontWeight: FontWeight.normal,
    fontFamily: "PingFangSC",
    fontStyle: FontStyle.normal,
    fontSize: ASize.ft(8),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF070A10),
      body: SizedBox.expand(
        child: Stack(children: [
          const Positioned.fill(child: TechTravelBackground()),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66040D1D),
                    Color(0xAA101342),
                    Color(0xCC050B1A),
                  ],
                ),
              ),
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
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ASize.w(5), vertical: ASize.h(5)),
                    decoration: _glassDecoration(),
                    child: Obx(() => (controller.username.value == '')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text("暱稱:", style: titleName),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Container(
                                        width: ASize.w(80),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.08),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: const Color(0x5555E6FF)),
                                        ),
                                        child: CupertinoTextField(
                                          textAlign: TextAlign.center,
                                          controller: controller
                                              .textEditingController,
                                          keyboardType: TextInputType.text,
                                          cursorColor: const Color(0xFF55E6FF),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "PingFangSC",
                                            fontSize: ASize.ft(8),
                                          ),
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          maxLines: 1,
                                          maxLength: 10,
                                          placeholder: "請輸入暱稱",
                                          placeholderStyle: TextStyle(
                                            color: Colors.white54,
                                            fontFamily: "PingFangSC",
                                            fontSize: ASize.ft(8),
                                          ),
                                          onChanged: (value) {
                                            if (kDebugMode) {
                                              print(value);
                                            }
                                            controller.draftUsername.value =
                                                value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  if (controller.draftUsername.value
                                      .isNotEmpty) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    controller.updateUsername(
                                        controller.draftUsername.value);
                                    controller.username.value =
                                        controller.draftUsername.value;
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ASize.w(5)),
                                  height: ASize.h(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: controller
                                              .draftUsername.value.isNotEmpty
                                          ? const [
                                              Color(0xFF19687B),
                                              Color(0xFF49368C),
                                            ]
                                          : const [
                                              Color(0x552A3546),
                                              Color(0x55131B2C),
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: controller
                                              .draftUsername.value.isNotEmpty
                                          ? const Color(0x8C55E6FF)
                                          : const Color(0x334E6A85),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "確認",
                                      style: TextStyle(
                                        color: controller
                                                .draftUsername.value.isNotEmpty
                                            ? Colors.white
                                            : Colors.white38,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "PingFang-SC",
                                        fontStyle: FontStyle.normal,
                                        fontSize: ASize.ft(7),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text("暱稱:", style: titleName),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Text(
                                        controller.username.value,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "PingFangSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: ASize.ft(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  controller.changeUsername();
                                  controller.username.value = '';
                                  controller.draftUsername.value = '';
                                },
                                child: Container(
                                  height: ASize.h(14),
                                  width: ASize.w(28),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF19687B),
                                        Color(0xFF49368C),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0x8C55E6FF)),
                                  ),
                                  child: Center(
                                    child: Text("替換", style: titleName),
                                  ),
                                ),
                              ),
                            ],
                          )),
                  ),
                ),
                CommentViewMessageBoard(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100, right: 16, top: 16),
              child: GradientPillButton(
                text: '更多資訊',
                icon: Icons.info_outline_rounded,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        content: PopViewSettingPage(controller: controller),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100, left: 16, top: 16),
              child: InkWell(
                onTap: () async {
                  controller.startAnimation();
                  await controller.fetchApi();
                  controller.stopAnimation();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      width: ASize.w(16),
                      height: ASize.h(16),
                      decoration: _glassDecoration(),
                      child: AnimatedBuilder(
                        animation: controller.animationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: controller.animationController.value *
                                2.0 *
                                3.1415927,
                            child: const Icon(
                              Icons.refresh,
                              color: Color(0xFF8CF3FF),
                            ),
                          );
                        },
                      ),
                    ),
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
                decoration: _glassDecoration(),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: CupertinoTextField(
                          textAlign: TextAlign.start,
                          controller: controller.messageController,
                          keyboardType: TextInputType.text,
                          cursorColor: const Color(0xFF55E6FF),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "PingFangSC",
                          ),
                          maxLines: 1,
                          maxLength: 30,
                          placeholder: "留下你的心得吧!",
                          placeholderStyle: TextStyle(
                            color: Colors.white54,
                            fontFamily: "PingFangSC",
                            fontSize: ASize.ft(8),
                          ),
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
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: GestureDetector(
                        onTap: () {
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
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF19687B),
                                Color(0xFF49368C),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0x8C55E6FF)),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
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

  BoxDecoration _glassDecoration({
    Color borderColor = const Color(0x6655E6FF),
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xD9162940), Color(0xD90C1327)],
      ),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: borderColor),
      boxShadow: const [
        BoxShadow(
          color: Color(0x44000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}
