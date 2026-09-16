import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/style_info.dart';
import '../data/mode/comment_model.dart';
import '../ui/detail/detail_controller.dart';
import '../util/ui_util.dart';
import 'tech_detail_widgets.dart';

class CommentView extends StatelessWidget {
  CommentView({Key? key}) : super(key: key);
  final DetailController controller = Get.find<DetailController>();
  String sendData = '';

  static final TextStyle _textName = TextStyle(
      fontSize: ASize.ft(8.0),
      fontWeight: FontWeight.bold,
      color: StyleInfo.infoTextUserNameColor,
      fontFamily: "PingFangSC");

  static final TextStyle _textComment = TextStyle(
      fontSize: ASize.ft(6.0),
      fontWeight: FontWeight.normal,
      color: const Color(0xFF3A3A3A),
      height: 1.4,
      fontFamily: "PingFangSC");

  static final TextStyle _textInfo = TextStyle(
      fontSize: ASize.ft(5.5),
      fontWeight: FontWeight.w200,
      color: const Color(0xFFAAAAAA),
      fontFamily: "PingFangSC");

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StyleInfo.infoBGColor,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 8.0, bottom: 5.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  // Loading state
                  if (controller.isLoading.value &&
                      controller.dataList.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF49368C),
                        strokeWidth: 2.5,
                      ),
                    );
                  }

                  // Empty state
                  if (controller.dataList.isEmpty) {
                    return const CommentEmptyState();
                  }

                  // Comment list
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemCount: controller.dataList.length,
                    itemBuilder: (context, index) {
                      CommentModel item = controller.dataList[index];
                      if (item.username == null) {
                        return SizedBox(width: ASize.w(5));
                      }
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFFE8E6E4), width: 0.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () => controller.onTap(item),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF49368C),
                                          Color(0xFF19687B),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: Text(
                                        item.username!.isNotEmpty
                                            ? item.username![0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.username!,
                                      style: _textName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.comment?.replaceAll(' ', '') ?? '',
                                style: _textComment,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.timeStamp ?? '',
                                style: _textInfo,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Input bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                    color: const Color(0xFF49368C).withValues(alpha: 0.3),
                    width: 1.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 5),
                      child: CupertinoTextField(
                        textAlign: TextAlign.start,
                        controller: controller.messageController,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        maxLength: 30,
                        placeholder: "寫下你的感想",
                        placeholderStyle: TextStyle(
                            color: const Color(0xFFB0B0B0),
                            fontSize: ASize.ft(6)),
                        style: TextStyle(
                            color: Colors.black, fontSize: ASize.ft(6)),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onChanged: (value) {
                          sendData = value;
                          if (kDebugMode) {
                            print('sendData:$sendData');
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        controller.messageController.text = '';
                        controller.checkSendData(context, sendData,
                            callback: (value) {
                          if (value == 'ok') {
                            controller.fetchApi();
                          }
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF19687B), Color(0xFF49368C)],
                          ),
                          borderRadius: BorderRadius.circular(10),
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
            SizedBox(height: ASize.h(10)),
          ],
        ),
      ),
    );
  }
}
