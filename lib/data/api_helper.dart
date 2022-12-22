import 'dart:convert';

import 'package:get/get_connect/connect.dart';

import 'mode/data_all.dart';
import 'mode/post_model.dart';

class ApiHelper extends GetConnect {
  Future<List<DataAll>> fetchAllData() async {
    return await get(
      'https://raw.githubusercontent.com/qn5566/travel/main/all_data.json',
      decoder: (data) =>
          List<DataAll>.from(json.decode(data).map((e) => DataAll.fromJson(e))),
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
