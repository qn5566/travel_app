import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/home/home_controller.dart';

import '../data/mode/data_all.dart';

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
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      color: Colors.white,
                      border: Border.all(color: Colors.blueAccent, width: 2.0)),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: item.title ?? '',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.red),
                        ),
                        TextSpan(
                          text: "\n地區：${item.region}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        TextSpan(
                          text: '\n地址：${item.address ?? ''}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ));
            },
          ));
  }
}
