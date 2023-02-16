import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
        Positioned.fill(
          child: Image.asset(
            'images/info/background_club.png',
            fit: BoxFit.fill,
          ),
        ),
        // 毛玻璃效果 - 半透明
        Container(
          color: const Color(0xFF0E3311).withOpacity(0.5),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: ASize.w(5), left: ASize.w(5), right: ASize.w(5)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [buildTitle('聯絡電話'), buildText(' - 點擊撥打')],
                        ),
                        buildText(controller.item.tel ?? '暫時無資料'),
                      ],
                    ),
                    onTap: () {
                      controller.call(
                          Uri(scheme: 'tel', path: "+${controller.item.tel}"));
                    },
                  ),
                  (controller.item.address != '')
                      ? InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildTitle('地址資訊'),
                                  buildText(' - 點擊複製')
                                ],
                              ),
                              buildText(controller.item.address ?? '暫時無資料'),
                            ],
                          ),
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: controller.item.address ?? '暫時無資料'));
                            ToastUtil.info(context, "複製成功!");
                          },
                        )
                      : const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      child: buildTitle('開啟導航'),
                      onTap: () {
                        // var uri = Uri.parse(controller.item.map!);
                        controller.call(Uri(
                            scheme: 'https',
                            host: 'www.google.com',
                            path:
                                '/maps/search/${(controller.item.address != null) ? controller.item.address : controller.item.title}'));
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child:
                        Icon(Icons.assistant_navigation, color: Colors.white),
                  ),
                  (controller.item.opentime != '')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitle('營業時間'),
                            buildText(controller.item.opentime!),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (controller.item.ticketinfo != '')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitle('門票'),
                            buildText(controller.item.ticketinfo!),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (controller.item.travellinginfo != '')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitle('旅遊資訊'),
                            buildText(controller.item.travellinginfo!),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (controller.item.toldescribe == '')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitle('詳細資訊'),
                            buildText(controller.item.toldescribe!),
                          ],
                        )
                      : (controller.item.description != '')
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTitle('詳細資訊'),
                                buildText(controller.item.description!),
                              ],
                            )
                          : const SizedBox.shrink(),
                  (controller.item.remarks != '')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitle('注意事項'),
                            buildText(controller.item.remarks!),
                          ],
                        )
                      : const SizedBox.shrink(),
                  SizedBox(height: ASize.h(30)),
                  (controller.item.changetime != '')
                      ? buildText('最後更新時間\n${controller.item.changetime!}')
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
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: "PingFangSC",
          fontStyle: FontStyle.normal,
          fontSize: ASize.ft(8),
          backgroundColor: const Color(0xFFf6f6f6).withOpacity(0.5),
        ),
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 文字設定
  Padding buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: "PingFangSC",
          fontStyle: FontStyle.normal,
          fontSize: ASize.ft(8),
        ),
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
