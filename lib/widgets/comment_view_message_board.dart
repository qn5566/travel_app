import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/ui/account/account_controller.dart';

import '../data/mode/comment_model.dart';
import '../util/ui_util.dart';
import 'dashed_divider.dart';

class CommentViewMessageBoard extends StatefulWidget {
  const CommentViewMessageBoard({super.key});

  @override
  State<CommentViewMessageBoard> createState() =>
      _CommentViewMessageBoardState();
}

class _CommentViewMessageBoardState extends State<CommentViewMessageBoard> {
  final AccountController controller = Get.find<AccountController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static final TextStyle _textName = TextStyle(
      fontSize: ASize.ft(8.0),
      fontWeight: FontWeight.bold,
      color: const Color(0xFF8CF3FF));

  static final TextStyle _textComment = TextStyle(
      fontSize: ASize.ft(6.0),
      fontWeight: FontWeight.normal,
      color: Colors.white);

  static final TextStyle _textInfo = TextStyle(
      fontSize: ASize.ft(6.0),
      fontWeight: FontWeight.w200,
      color: Colors.white54);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      }
    });

    return Stack(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            height: ASize.h(220),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8,),
                  Text(
                    '留言板',
                    style: TextStyle(
                      fontSize: ASize.ft(10.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Obx(
                    () => Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
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
                                        color: const Color(0x4455E6FF),
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
