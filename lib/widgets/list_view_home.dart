import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../config/global_config.dart';
import '../data/mode/data_all.dart';
import '../ui/home/home_controller.dart';
import '../util/ui_util.dart';
import 'money_text_widget.dart';

class ListViewHome extends StatelessWidget {
  ListViewHome({Key? key}) : super(key: key);
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: controller.dataList.length,
            itemBuilder: (context, index) {
              DataAll item = controller.dataList[index];
              return GestureDetector(
                onTap: () {
                  controller.onTap(item);
                },
                child: Container(
                  // color: Colors.transparent,
                  color: Colors.black38,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.7777777,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: VideoCoverView(
                                radius: 10,
                                cover: item.picture1 ?? '',
                                money: item.region,
                                name: '',
                              ),
                            ),
                            // Positioned(
                            //   top: ASize.w(4),
                            //   right: ASize.w(4),
                            //   child: Offstage(
                            //     offstage: !widget.item.isPlus,
                            //     child: Image.asset(
                            //       'images/home/video_plus_icon.png',
                            //       height: ASize.w(20),
                            //     ),
                            //   ),
                            // ),
                            // IsFreeWidget(widget.item),
                            MoneytextWidget(item.region ?? "尚未資料")
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: ASize.w(1), left: ASize.w(1)),
                        child: Text(
                          item.title,
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: ASize.w(1),
                            left: ASize.w(1),
                            bottom: ASize.w(4)),
                        child: Text(
                          item.address ?? emptyData,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: ASize.ft(6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      /// 電話顯示
                      // Padding(
                      //   padding: EdgeInsets.only(top: ASize.w(1)),
                      //   child: Row(
                      //     children: [
                      //       Padding(
                      //         padding:
                      //         EdgeInsets.only(left: ASize.w(3), right: ASize.w(3)),
                      //         child: Image.asset(
                      //           'images/icon/telephone.png',
                      //           width: ASize.w(8),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: Text(
                      //           item.tel ?? '',
                      //           style: TextStyle(
                      //               fontSize: ASize.ft(10.0),
                      //               fontWeight: FontWeight.w500,
                      //               color: StyleInfo.white),
                      //           maxLines: 1,
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //       ),
                      //
                      //       /// 靠右邊
                      //       // Text(
                      //       //   '00:00',
                      //       //   style: TextStyle(
                      //       //       fontSize: ASize.ft(12.0),
                      //       //       fontWeight: FontWeight.w500,
                      //       //       color: StyleInfo.white_04),
                      //       // )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),

                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: const BorderRadius.all(Radius.circular(16)),
                //       color: Colors.white,
                //       border: Border.all(color: Colors.blueAccent, width: 2.0)),
                //   margin: const EdgeInsets.all(8),
                //   padding: const EdgeInsets.all(8),
                //   child: RichText(
                //     text: TextSpan(
                //       style: DefaultTextStyle.of(context).style,
                //       children: <TextSpan>[
                //         TextSpan(
                //           text: item.title ?? '',
                //           style:
                //               const TextStyle(fontSize: 18, color: Colors.red),
                //         ),
                //         TextSpan(
                //           text: "\n地區：${item.region}",
                //           style: const TextStyle(fontSize: 18),
                //         ),
                //         TextSpan(
                //           text: '\n地址：${item.address ?? ''}',
                //           style: const TextStyle(fontWeight: FontWeight.bold),
                //         ),
                //       ],
                //     ),
                //   ));
              );
            },
          ));
  }
}
