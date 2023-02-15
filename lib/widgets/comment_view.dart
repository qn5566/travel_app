import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/style_info.dart';
import '../data/mode/comment_model.dart';
import '../ui/detail/detail_controller.dart';
import '../util/ui_util.dart';

class CommentView extends StatelessWidget {
  CommentView({Key? key}) : super(key: key);
  final DetailController controller = Get.find<DetailController>();
  String sendData = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'images/info/background_commit.png',
            fit: BoxFit.cover,
          ),
        ),
        // 毛玻璃效果 - 半透明
        Container(
          color: const Color(0xFF0E3311).withOpacity(0.5),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemCount: controller.dataList.length,
                    itemBuilder: (context, index) {
                      CommentModel item = controller.dataList[index];
                      return (item.username != null)
                          ? GestureDetector(
                              onTap: () {
                                controller.onTap(item);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.username!,
                                    style: TextStyle(
                                        fontSize: ASize.ft(10.0),
                                        fontWeight: FontWeight.w500,
                                        color: StyleInfo.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    item.comment!,
                                    style: TextStyle(
                                        fontSize: ASize.ft(8.0),
                                        fontWeight: FontWeight.w500,
                                        color: StyleInfo.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    item.timeStamp!,
                                    style: TextStyle(
                                        fontSize: ASize.ft(6.0),
                                        fontWeight: FontWeight.w500,
                                        color: StyleInfo.white_07),
                                  ),
                                  SizedBox(height: ASize.h(2)),
                                  const Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              width: ASize.w(5),
                            );
                    },
                  ),
                ),
              ),
              Container(
                // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                height: 50,
                color: Colors.white,
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
                          placeholder: "寫下你的感想",
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                          onChanged: (value) {
                            sendData = value;
                            if (kDebugMode) {
                              print('sendData:$sendData');
                            }
                          },
                        ),
                      ),
                    ),
                    // const SizedBox(width: 15),
                    FloatingActionButton.small(
                      onPressed: () {
                        // 關閉鍵盤
                        FocusScope.of(context).unfocus();
                        // 清除文字
                        controller.messageController.text = '';
                        controller.checkSendData(sendData, callback: (value) {
                          if (value == 'ok') {
                            controller.fetchApi();
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
            ],
          ),
        ),
      ],
    );
  }
}
