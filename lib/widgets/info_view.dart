import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/detail/detail_controller.dart';
import '../util/ui_util.dart';

class InfoView extends StatelessWidget {
  InfoView({Key? key}) : super(key: key);
  final DetailController controller = Get.find<DetailController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: ASize.w(5), left: ASize.w(5),right: ASize.w(5)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Get.arguments.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: "PingFangSC",
                fontStyle: FontStyle.normal,
                fontSize: ASize.ft(8),
              ),
            ),
            Text(
              Get.arguments.tel,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: "PingFangSC",
                fontStyle: FontStyle.normal,
                fontSize: ASize.ft(8),
              ),
              // overflow: TextOverflow.ellipsis,
            ),
            (Get.arguments.toldescribe == '')
                ? Text(
                    Get.arguments.toldescribe,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: ASize.ft(8),
                    ),
                  )
                : Text(
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
          ]),
    );
  }
}
