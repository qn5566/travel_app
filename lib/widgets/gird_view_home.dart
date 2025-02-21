import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../data/mode/data_all.dart';
import '../ui/home/home_controller.dart';
import '../util/ui_util.dart';

class GridViewHome extends StatelessWidget {
  GridViewHome({Key? key, required this.site}) : super(key: key);
  final String site;
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    controller.searchData(site);
    return Obx(
      () => controller.firstLoading.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/car.json'),
                const Text(
                  '第一次下載會比較久請稍等..',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )
          : controller.isLoading.value
              ? Lottie.asset('assets/loading.json')
              : (controller.dataList.isNotEmpty)
                  ? MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 3 列
                          childAspectRatio: 0.75, // 調整子項目比例
                        ),
                        itemCount: controller.dataList.length,
                        itemBuilder: (context, index) {
                          DataAll item = controller.dataList[index];
                          return GestureDetector(
                            onTap: () {
                              controller.onTap(item);
                            },
                            child: Container(
                              color: Colors.white,
                              child: Stack(
                                children: [
                                  VideoCoverView(
                                    cover: item.picture1 ?? '',
                                    money: item.region,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 2.0),
                                      child: Container(
                                        color: Colors.grey.withOpacity(0.5),
                                        child: Text(
                                          item.name!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: "PingFangSC",
                                            fontStyle: FontStyle.normal,
                                            fontSize: ASize.ft(6),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/icon/no_data.png',
                                  fit: BoxFit.none,
                                ),
                                const Text(
                                  '無資料',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
