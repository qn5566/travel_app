import 'dart:convert';

import 'package:get/get_connect/connect.dart';

import 'mode/comment_model.dart';
import 'mode/data_all.dart';

/// 資料取得的地方
class ApiHelper extends GetConnect {
  Future<List<DataAll>> fetchAllData() async {
    return await get(
      'https://raw.githubusercontent.com/qn5566/travel/main/all_data.json',
      // 'http://10.0.2.2:5000/data',
      contentType: 'application/json; charset=utf-8',
      decoder: (data) {
        // print(data);
        return List<DataAll>.from(
            json.decode(data).map((e) => DataAll.fromJson(e)));
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }

  /// 取得data進入db
  Future<List<Map<String, dynamic>>> fetchAllDataToDb() async {
    return await get(
      'https://raw.githubusercontent.com/qn5566/travel/main/all_data.json',
      // 'http://10.0.2.2:5000/data',
      contentType: 'application/json; charset=utf-8',
      decoder: (data) {
        // print(data);
        return List<Map<String, dynamic>>.from(
          json.decode(data).map((e) {
            DataAll temp = DataAll.fromJson(e);
            return temp.toJson();
          }),
        );
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }

  /// 取得評論的資料
  Future<List<CommentModel>> fetchCommentData(String titleId) async {
    Map<String, dynamic> body = {'TitleId': titleId, 'fun': 'getComment'};
    return await post(
      'https://himydream.me/app/main.php',
      // 'http://10.0.2.2/app/main.php',
      FormData(body),
      decoder: (data) {
        return List<CommentModel>.from(
            json.decode(data).map((e) => CommentModel.fromJson(e)));
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }

  /// 傳送評論資料
  Future<String> sendCommentData(Map<String, dynamic> body) async {
    return await post(
      'https://himydream.me/app/main.php',
      // 'http://10.0.2.2/app/main.php',
      FormData(body),
      decoder: (data) {
        return json.decode(data);
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }

  /// 版本控管API
  Future<Map<String, dynamic>> getInfoData() async {
    return await get(
      'https://raw.githubusercontent.com/qn5566/travel/main/info.json',
      contentType: 'application/json; charset=utf-8',
      decoder: (data) {
        return json.decode(data);
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }
}
