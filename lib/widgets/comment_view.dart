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
    return Padding(
      padding: const EdgeInsets.all(5.0),
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
                  return GestureDetector(
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
                        SizedBox(height: ASize.h(5)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 30,
                    decoration: const InputDecoration(
                      hintText: "寫下你的感想",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      sendData = value;
                      if (kDebugMode) {
                        print('sendData:$sendData');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 15),
                FloatingActionButton.small(
                  onPressed: () {
                    // 關閉鍵盤
                    FocusScope.of(context).unfocus();
                    controller.checkSendData(sendData, callback: (value) {
                      if (value == 'ok') {
                        controller.fetchApi();

                        controller.messageController.text = '';
                      }
                    });
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
