import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/ui/account/account_controller.dart';

import '../config/style_info.dart';
import '../data/mode/comment_model.dart';
import '../util/ui_util.dart';
import 'DashedDivider.dart';

class CommentViewMessageBoard extends StatelessWidget {
  CommentViewMessageBoard({Key? key}) : super(key: key);
  final AccountController controller = Get.find<AccountController>();
  String sendData = '';

  static final TextStyle _textName = TextStyle(
      fontSize: ASize.ft(8.0),
      fontWeight: FontWeight.bold,
      color: StyleInfo.infoTextUserNameColor);

  static final TextStyle _textComment = TextStyle(
      fontSize: ASize.ft(6.0),
      fontWeight: FontWeight.normal,
      color: StyleInfo.infoTextColor);

  static final TextStyle _textInfo = TextStyle(
      fontSize: ASize.ft(6.0),
      fontWeight: FontWeight.w200,
      color: StyleInfo.infoTextColor);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            height: ASize.h(200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    '留言板',
                    style: TextStyle(
                      fontSize: ASize.ft(10.0),
                      fontWeight: FontWeight.bold,
                      color: StyleInfo.infoTextColor,
                    ),
                  ),
                  Obx(
                    () => Expanded(
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemCount: controller.dataListComment.length,
                        itemBuilder: (context, index) {
                          CommentModel item = controller.dataListComment[index];
                          return (item.username != null)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.username!,
                                              style: _textName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              item.comment!.replaceAll(' ', ''),
                                              style: _textComment,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          item.timeStamp!,
                                          style: _textInfo,
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1),
                                      child: DashedDivider(
                                        color: StyleInfo.infoTextColor,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  width: ASize.w(5),
                                );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
