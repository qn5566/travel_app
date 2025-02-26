import 'dart:convert';

import 'package:get/get.dart';

import '../config/global_config.dart';
import '../config/rx_config.dart';
import 'mode/comment_model.dart';
import 'mode/data_all.dart';

/// 資料取得的地方
class ApiHelper extends GetConnect {
  RxConfig userData = Get.find();

  /// 取得景點資訊的API
  Future<DataHome> fetchAllData() async {
    return await get(
      userData.dataAPI[0],
      contentType: 'application/json; charset=utf-8',
      decoder: (data) {
        return DataHome.fromJson(data);
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }

  /// 取得評論的資料
  Future<List<CommentModel>> fetchCommentData(String titleId) async {
    Map<String, dynamic> body = {'TitleId': titleId, 'fun': 'getComment'};
    return await post(
      baseMainUrl,
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
      baseMainUrl,
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

  /// 傳送點擊紀錄
  Future<String> sendHistory(Map<String, dynamic> body) async {
    return await post(
      baseMainUrl,
      FormData(body),
      decoder: (data) {
        return json.decode(data);
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }

  /// 獲取最新的留言
  Future<List<CommentModel>> getNewComment() async {
    Map<String, dynamic> body = {
      'fun': 'getCommentNews',
      'limit': 10,
    };
    return await post(
      baseMainUrl,
      FormData(body),
      decoder: (data) {
        return List<CommentModel>.from(
            json.decode(data).map((e) => CommentModel.fromJson(e)));
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }

  /// 取得評論的資料
  Future<List<CommentModel>> fetchCommentDataMessageBoard() async {
    Map<String, dynamic> body = {'limit': 50, 'fun': 'getMessageBoard'};
    return await post(
      baseMainUrl,
      FormData(body),
      decoder: (data) {
        return List<CommentModel>.from(
            json.decode(data).map((e) => CommentModel.fromJson(e)));
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }

  /// 傳送評論資料
  Future<String> sendCommentDataMessageBoard(Map<String, dynamic> body) async {
    return await post(
      baseMainUrl,
      FormData(body),
      decoder: (data) {
        return json.decode(data);
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }
}
