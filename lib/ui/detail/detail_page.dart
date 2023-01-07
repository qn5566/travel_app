import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/ui_util.dart';
import '../../widgets/money_text_widget.dart';
import '../../widgets/views/video_cover_view.dart';
import 'detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.zero,
          child: AppBar(
            elevation: 0,
            // backgroundColor: StyleInfo.main_bg,
            // brightness: Brightness.dark,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.7777777,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: VideoCoverView(
                          radius: 10,
                          cover: Get.arguments.picture1 ?? '',
                          money: Get.arguments.region,
                          name: '',
                        ),
                      ),
                      MoneytextWidget(Get.arguments.region ?? "尚未資料"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ASize.w(1), left: ASize.w(1)),
                  child: Text(
                    Get.arguments.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: ASize.ft(8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                (Get.arguments.toldescribe == '')
                    ? Padding(
                        padding:
                            EdgeInsets.only(top: ASize.w(1), left: ASize.w(1)),
                        child: Text(
                          Get.arguments.toldescribe,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: ASize.ft(8),
                          ),
                          // overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.only(top: ASize.w(1), left: ASize.w(1)),
                        child: Text(
                          Get.arguments.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: ASize.ft(8),
                          ),
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                // DefaultTabController(
                //   length: DetailController.subTitle.length,
                //   child: Scaffold(
                //     appBar: AppBar(
                //       elevation: 0.0,
                //       // title: const Text('Colors'),
                //       // bottom: TabBar(
                //       //   isScrollable: true,
                //       //   tabs: DetailController.subTitle
                //       //       .map<Widget>(
                //       //           (Palette swatch) => Tab(text: '$_counter:${swatch.name}'))
                //       //       .toList(),
                //       // ),
                //     ),
                //     // body: TabBarView(
                //     //   children: DetailController.subTitle.map<Widget>((Palette colors) {
                //     //     return PaletteTabView(colors: colors);
                //     //   }).toList(),
                //     // ),
                //   ),
                // ),

                // Obx(() => Text("Counter ${controller.counter.value}")),
                // ElevatedButton(
                //   child: const Text("Increase"),
                //   onPressed: () => controller.increaseCounter(),
                // )
              ],
            ),
          ),
        ));
  }
}
