import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      color: const Color(0xFFEAF3FF),
      fontFamily: "PingFangSC");

  static final TextStyle _textComment = TextStyle(
      fontSize: ASize.ft(6.0),
      fontWeight: FontWeight.normal,
      color: const Color(0xFFC7D4E5),
      height: 1.4,
      fontFamily: "PingFangSC");

  static final TextStyle _textInfo = TextStyle(
      fontSize: ASize.ft(5.5),
      fontWeight: FontWeight.w200,
      color: const Color(0xFF7A8BA3),
      fontFamily: "PingFangSC");

  static final TextStyle _textHint = TextStyle(
      fontSize: ASize.ft(4.5),
      fontWeight: FontWeight.w200,
      color: const Color(0xFF64748B),
      fontFamily: "PingFangSC");

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
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
                        color: Color(0xFF55E6FF),
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
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xE61B2E52), Color(0xE60D1730)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0x3355E6FF), width: 0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                            const BoxShadow(
                              color: Color(0x1455E6FF),
                              blurRadius: 14,
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
                                          Color(0xFF7C5CFF),
                                          Color(0xFF55E6FF),
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
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xE61B2E52), Color(0xE60D1730)],
                ),
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: const Color(0x3355E6FF), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(0, 3),
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
                            color: const Color(0xFF64748B),
                            fontSize: ASize.ft(6)),
                        style: TextStyle(
                            color: const Color(0xFFEAF3FF),
                            fontSize: ASize.ft(6)),
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
                    child: Obx(
                      () => GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                final text = controller.messageController.text;
                                controller
                                    .checkSendData(context, text)
                                    .then((success) {
                                  if (!success) return;
                                  controller.messageController.clear();
                                  controller.fetchApi();
                                });
                              },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: controller.isLoading.value
                                  ? [
                                      const Color(0xFF9E9E9E),
                                      const Color(0xFF757575),
                                    ]
                                  : const [
                                      Color(0xFF55E6FF),
                                      Color(0xFF7C5CFF),
                                    ],
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
                  ),
                ],
              ),
            ),
            SizedBox(height: ASize.h(1)),
            Text(
              "請友善留言，勿輸入個資或不當內容",
              style: _textHint,
            ),
            SizedBox(height: ASize.h(2)),
          ],
        ),
      ),
    );
  }
}
