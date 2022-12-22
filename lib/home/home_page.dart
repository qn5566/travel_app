import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/list_view_home.dart';
import 'home_controller.dart';

/*
首頁頁面
 */
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            controller.title,
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            PopupMenuButton<SortState>(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: SortState.region,
                  child: Text('使用 region 排序'),
                ),
                const PopupMenuItem(
                  value: SortState.id,
                  child: Text('使用 id 排序'),
                ),
                const PopupMenuItem(
                  value: SortState.title,
                  child: Text('使用 title 排序'),
                ),
                const PopupMenuItem(
                  value: SortState.siteLevel,
                  child: Text('使用 siteLevel 排序'),
                )
              ],
              onSelected: (SortState value) {
                Get.find<HomeController>().sort(value);
              },
            )
          ],
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: ListViewHome());
  }
}
