import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:travel/ui/search/search_controller.dart';
import 'package:travel/widgets/list_view_search.dart';

import '../../config/style_info.dart';
import '../../util/ui_util.dart';

class SearchPage extends GetView<SearchController> {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          body: Container(
            color: Colors.white70,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'images/search/background_search.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                // 毛玻璃效果 - 半透明
                // Container(
                //   color: const Color(0xFF0E3311).withOpacity(0.5),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    Padding(
                      //标题栏
                      padding:
                          EdgeInsets.only(top: ScreenUtil().statusBarHeight),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: EdgeInsets.only(left: ASize.w(5)),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text('搜尋',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: ASize.ft(8),
                              )),
                          const SizedBox(width: 36.0),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _searchBar(context, '請輸入關鍵字', height: ASize.h(20)),
                    const SizedBox(height: 5.0),
                    Expanded(child: ListViewSearch(site: controller.keywords)),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// 搜索栏
  Widget _searchBar(BuildContext context, String placeholderText,
      {required double height}) {
    return Container(
      height: height,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(left: ASize.w(10), right: ASize.w(10)),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 5,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: CupertinoTextField(
                        controller: controller.messageController,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        maxLength: 10,
                        placeholder: placeholderText,
                        placeholderStyle: TextStyle(
                            fontSize: ASize.ft(6),
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        onChanged: (value) {
                          controller.keywords.value = value;
                          if (kDebugMode) {
                            print('keywords:${controller.keywords.value}');
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: ASize.w(2),
                        ),
                        child: SizedBox(
                          height: ASize.h(16),
                          width: ASize.w(30),
                          child: Center(
                            child: Text("搜索",
                                style: TextStyle(
                                    color:
                                        (controller.keywords.value.isNotEmpty)
                                            ? Colors.black
                                            : StyleInfo.gray_7C7C8D,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PingFang-SC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: ASize.ft(7))),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (controller.keywords.value.isNotEmpty) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          // 搜索
                          controller.searchData(controller.keywords.value);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
