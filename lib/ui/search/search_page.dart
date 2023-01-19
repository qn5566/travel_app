import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:travel/ui/search/search_controller.dart';

import '../../config/style_info.dart';
import '../../util/ui_util.dart';

class SearchPage extends GetView<SearchController> {
  SearchPage({Key? key}) : super(key: key);
  String _keywords = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          body: Container(
            color: Colors.grey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  //标题栏
                  padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
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
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text('搜尋',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: ASize.ft(10),
                          )),
                      const SizedBox(width: 36.0),
                    ],
                  ),
                ),
                _searchBar(context, '請輸入關鍵字', height: ASize.h(16)),
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
        padding: EdgeInsets.only(left: ASize.w(5), right: ASize.w(5)),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: ASize.h(38),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(ASize.w(18))),
                    color: Colors.orange),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                      ),
                      child: Image.asset(
                        'images/home/home_search.png',
                        width: ASize.w(10),
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
                            color: StyleInfo.white),
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        onChanged: (value) {
                          _keywords = value;
                          if (kDebugMode) {
                            print('keywords:$_keywords');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: ASize.w(5))),
            GestureDetector(
              child: Container(
                height: height,
                width: ASize.w(30),
                decoration: BoxDecoration(
                    color:
                        (_keywords.isNotEmpty) ? Colors.black : Colors.orange,
                    borderRadius:
                        BorderRadius.all(Radius.circular(ASize.w(30)))),
                child: Center(
                  child: Text("搜索",
                      style: TextStyle(
                          color: (_keywords.isNotEmpty)
                              ? Colors.black
                              : StyleInfo.gray_7C7C8D,
                          fontWeight: FontWeight.w700,
                          fontFamily: "PingFang-SC",
                          fontStyle: FontStyle.normal,
                          fontSize: ASize.ft(7))),
                ),
              ),
              onTap: () {
                if (_keywords.isNotEmpty) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  // 搜索
                  // _doSearch(_keywords);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
