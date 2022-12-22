import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../data/mode/post_model.dart';
import '../data/post_controller.dart';

class MyListView extends StatelessWidget {
  MyListView({Key? key}) : super(key: key);
  final PostController controller = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: controller.postList.length,
            itemBuilder: (context, index) {
              PostModel item = controller.postList[index];
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Colors.white,
                      border: Border.all(color: Colors.blueAccent, width: 2.0)),
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: item.id.toString() + ". " + item.title!,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                        TextSpan(
                          text: '\n' + item.body!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "\nUser ID：" + item.userId.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ));
            },
          ));
  }
}
