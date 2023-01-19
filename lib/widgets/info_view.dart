import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/detail/detail_controller.dart';
import '../util/ui_util.dart';

class InfoView extends StatelessWidget {
  InfoView({Key? key}) : super(key: key);
  final DetailController controller = Get.find<DetailController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: ASize.w(5), left: ASize.w(5), right: ASize.w(5)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: buildText('聯絡電話\n${controller.item.tel!} - 立即詢問'),
                onTap: () {
                  controller.call(
                      Uri(scheme: 'tel', path: "+${controller.item.tel}"));
                },
              ),
              (controller.item.address != '')
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const Icon(Icons.assistant_navigation,
                              color: Colors.white),
                          Padding(
                            padding: EdgeInsets.only(left: ASize.w(2)),
                            child: InkWell(
                              child: buildText('開啟導航'),
                              onTap: () {
                                // var uri = Uri.parse(controller.item.map!);
                                controller.call(Uri(
                                    scheme: 'https',
                                    host: 'www.google.com',
                                    path:
                                        '/maps/search/${controller.item.address!}'));
                              },
                            ),
                          ),
                        ])
                  : const SizedBox.shrink(),
              (controller.item.opentime != '')
                  ? buildText('營業時間\n${controller.item.opentime!}')
                  : const SizedBox.shrink(),
              (controller.item.ticketinfo != '')
                  ? buildText('門票\n${controller.item.ticketinfo!}')
                  : const SizedBox.shrink(),
              (controller.item.travellinginfo != '')
                  ? buildText('旅遊資訊\n${controller.item.travellinginfo!}')
                  : const SizedBox.shrink(),
              (controller.item.toldescribe == '')
                  ? buildText('詳細資訊\n${controller.item.toldescribe!}')
                  : (controller.item.description != '')
                      ? buildText('詳細資訊\n${controller.item.description!}')
                      : const SizedBox.shrink(),
              (controller.item.remarks != '')
                  ? buildText('注意事項\n${controller.item.remarks!}')
                  : const SizedBox.shrink(),
              SizedBox(height: ASize.h(30)),
              (controller.item.changetime != '')
                  ? buildText('最後更新時間\n${controller.item.changetime!}')
                  : const SizedBox.shrink(),
            ]),
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
