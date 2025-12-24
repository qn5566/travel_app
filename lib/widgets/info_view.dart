import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../config/style_info.dart';
import '../ui/detail/detail_controller.dart';
import '../util/ToastUtil.dart';
import '../util/ui_util.dart';

class InfoView extends StatelessWidget {
  InfoView({Key? key}) : super(key: key);
  final DetailController controller = Get.find<DetailController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: StyleInfo.infoBGColor,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: ASize.w(5), left: ASize.w(5), right: ASize.w(5)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (controller.item!.website != '' &&
                          controller.item!.website != null)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: buildTextBottomLine('官方網站'),
                              onTap: () {
                                controller
                                    .call(Uri.parse(controller.item!.website!));
                              },
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTitle('聯絡電話'),
                            buildTextBottomLine(controller.item!.tel ?? '暫時無資料')
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      controller.call(
                          Uri(scheme: 'tel', path: "+${controller.item!.tel}"));
                    },
                  ),
                  (controller.item!.address != '' &&
                          controller.item!.address != null)
                      ? InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildTitle('地址資訊'),
                                  buildText(controller.item!.address ?? '暫時無資料')
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: controller.item!.address ?? '暫時無資料'));
                            ToastUtil.info(context, "複製成功!");
                          },
                        )
                      : const SizedBox.shrink(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: buildTitle('開啟導航'),
                        onTap: () {
                          // var uri = Uri.parse(controller.item!.map!);
                          controller.call(Uri(
                              scheme: 'https',
                              host: 'www.google.com',
                              path:
                                  '/maps/search/${(controller.item!.address != '' && controller.item!.address != null) ? controller.item!.address : controller.item!.name}'));
                        },
                      ),
                      InkWell(
                        child: const Icon(Icons.assistant_navigation,
                            color: Colors.blue),
                        onTap: () {
                          // var uri = Uri.parse(controller.item!.map!);
                          controller.call(Uri(
                              scheme: 'https',
                              host: 'www.google.com',
                              path:
                                  '/maps/search/${(controller.item!.address != '' && controller.item!.address != null) ? controller.item!.address : controller.item!.name}'));
                        },
                      ),
                    ],
                  ),
                  (controller.item!.opentime != '')
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTitle('營業時間'),
                            buildText(controller.item!.opentime!),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (controller.item!.ticketinfo != '' &&
                          controller.item!.ticketinfo != null)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTitle('門票'),
                            buildText(controller.item!.ticketinfo!),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (controller.item!.travellinginfo != '' &&
                          controller.item!.travellinginfo != null)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTitle('旅遊資訊'),
                            buildText(controller.item!.travellinginfo!),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (controller.item!.toldescribe == '' &&
                          controller.item!.description == '')
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTitle('詳細資訊'),
                            buildText(controller.item!.toldescribe!),
                          ],
                        )
                      : (controller.item!.description != '' &&
                              controller.item!.description != null)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildTitle('詳細資訊'),
                                buildText(controller.item!.description!),
                              ],
                            )
                          : const SizedBox.shrink(),
                  (controller.item!.remarks != '' &&
                          controller.item!.remarks != null)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTitle('注意事項'),
                            buildText(controller.item!.remarks!),
                          ],
                        )
                      : const SizedBox.shrink(),
                  SizedBox(height: ASize.h(10)),
                  (controller.item!.changetime != '')
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              buildTitle('更新時間'),
                              buildText(controller.item!.changetime ?? ''),
                            ])
                      : const SizedBox.shrink(),
                ]),
          ),
        ),
      ],
    );
  }

  /// 文字設定
  Padding buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Text(
        text,
        style: TextStyle(
          color: StyleInfo.infoTextColor,
          fontWeight: FontWeight.w500,
          fontFamily: "PingFangSC",
          fontStyle: FontStyle.normal,
          fontSize: ASize.ft(8),
        ),
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 文字設定
  Text buildText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: StyleInfo.infoTextColor,
        fontWeight: FontWeight.w500,
        fontFamily: "PingFangSC",
        fontStyle: FontStyle.normal,
        fontSize: ASize.ft(8),
      ),
      // overflow: TextOverflow.ellipsis,
    );
  }

  /// 底線文字設定
  Text buildTextBottomLine(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w500,
        fontFamily: "PingFangSC",
        fontStyle: FontStyle.normal,
        fontSize: ASize.ft(8),
        decoration: TextDecoration.underline,
        decorationColor: Colors.blue,
      ),
      // overflow: TextOverflow.ellipsis,
    );
  }
}
