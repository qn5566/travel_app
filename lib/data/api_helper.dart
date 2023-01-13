import 'dart:convert';

import 'package:get/get_connect/connect.dart';

import 'mode/comment_model.dart';
import 'mode/data_all.dart';
import 'mode/post_model.dart';

/// 資料取得的地方
class ApiHelper extends GetConnect {
  Future<List<DataAll>> fetchAllData() async {
    return await get(
      // 'https://raw.githubusercontent.com/qn5566/travel/main/all_data.json',
      'http://10.0.2.2:5000/data',
      contentType: 'application/json; charset=utf-8',
      decoder: (data) {
        print(data);
        return List<DataAll>.from(
            json.decode(data).map((e) => DataAll.fromJson(e)));
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }

  Future<List<CommentModel>> fetchCommentData(String titleId) async {
    Map<String, dynamic> body = {'TitleId': titleId};

    return await post(
      'http://10.0.2.2:5000/comment/get',
      FormData(body),
      decoder: (data)  {

        // print("success:"+data);
        // return List<CommentModel>.from(
            // data.map((e) => DataAll.fromJson(e)));
        return List<CommentModel>.from(
            json.decode(data).map((e) => CommentModel.fromJson(e)));
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }

  //  請求 Api
  Future<List<PostModel>> fetchData() async {
    return await get(
      'https://jsonplaceholder.typicode.com/posts',
      decoder: (data) =>
          List<PostModel>.from(data.map((e) => PostModel.fromJson(e))),
    ).then((value) => value.body!).catchError((e) => throw e);
  }
}
