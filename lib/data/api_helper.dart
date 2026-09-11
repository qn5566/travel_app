import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/global_config.dart';
import '../config/rx_config.dart';
import 'mode/comment_model.dart';
import 'mode/data_all.dart';
import 'mode/history_model.dart';

/// 資料取得的地方
class ApiHelper extends GetConnect {
  RxConfig userData = Get.find();

  /// 取得景點資訊的API
  Future<DataHome> fetchAllData({
    void Function(double progress)? onProgress,
  }) async {
    if (userData.dataAPI.isEmpty) {
      throw StateError('沒有設定景點資料 API');
    }

    Object? lastError;
    for (final url in userData.dataAPI) {
      try {
        final isZip = Uri.tryParse(url)?.path.toLowerCase().endsWith('.zip') ??
            url.toLowerCase().endsWith('.zip');
        if (isZip) {
          return await _fetchAttractionZip(url, onProgress: onProgress);
        }
        onProgress?.call(0.35);
        final response = await get<DataHome>(
          url,
          contentType: 'application/json; charset=utf-8',
          decoder: (data) {
            if (data is! Map<String, dynamic>) {
              throw const FormatException('景點資料格式錯誤');
            }
            return DataHome.fromJson(data);
          },
        );
        final body = response.body;
        if (body != null) {
          onProgress?.call(0.75);
          return body;
        }
        lastError = StateError('景點資料 API 回應為空（HTTP ${response.statusCode}）');
      } catch (error) {
        lastError = error;
      }
    }
    throw StateError('景點資料下載失敗：$lastError');
  }

  Future<DataHome> _fetchAttractionZip(
    String url, {
    void Function(double progress)? onProgress,
  }) async {
    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response =
          await client.send(request).timeout(const Duration(seconds: 90));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw StateError('景點 ZIP 下載失敗（HTTP ${response.statusCode}）');
      }

      final bytes = <int>[];
      var received = 0;
      final total = response.contentLength;
      await for (final chunk in response.stream
          .timeout(const Duration(seconds: 90))) {
        bytes.addAll(chunk);
        received += chunk.length;
        if (total != null && total > 0) {
          // Reserve 10% for request setup and 15% for ZIP parsing.
          onProgress?.call(
              (0.1 + (received / total).clamp(0.0, 1.0) * 0.75).toDouble());
        }
      }
      onProgress?.call(0.85);

      final zip = ZipDecoder().decodeBytes(bytes);
      ArchiveFile? fileNamed(String name) {
        for (final file in zip.files) {
          if (file.name.split('/').last.toLowerCase() == name.toLowerCase()) {
            return file;
          }
        }
        return null;
      }

      Map<String, dynamic>? decodeFile(ArchiveFile? file) {
        if (file == null || file.content is! List<int>) return null;
        final text =
            utf8.decode(file.content as List<int>).replaceFirst('\uFEFF', '');
        final value = json.decode(text);
        return value is Map<String, dynamic> ? value : null;
      }

      Map<String, Map<String, dynamic>> indexById(
          Map<String, dynamic>? value, String key) {
        final list = value?[key];
        if (list is! List) return {};
        return {
          for (final item in list.whereType<Map>())
            if (item['AttractionID'] != null)
              item['AttractionID'].toString(): Map<String, dynamic>.from(item),
        };
      }

      final attractionFile = fileNamed('AttractionList.json');
      if (attractionFile == null) {
        throw const FormatException('ZIP 中找不到 AttractionList.json');
      }
      final content = attractionFile.content;
      if (content is! List<int>) {
        throw const FormatException('AttractionList.json 無法讀取');
      }
      final jsonData =
          json.decode(utf8.decode(content).replaceFirst('\uFEFF', ''));
      if (jsonData is! Map<String, dynamic>) {
        throw const FormatException('AttractionList.json 格式錯誤');
      }
      final result = DataHome.fromAttractionJson(
        jsonData,
        serviceTimes: indexById(
            decodeFile(fileNamed('AttractionServiceTimeList.json')),
            'AttractionServiceTimes'),
        fees: indexById(
            decodeFile(fileNamed('AttractionFeeList.json')), 'AttractionFees'),
      );
      onProgress?.call(0.9);
      return result;
    } finally {
      client.close();
    }
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

  /// 獲取歷史排行榜
  Future<List<HistoryModel>> fetchHistoryRank() async {
    Map<String, dynamic> body = {
      'limit': 20,
      'fun': 'getHistoryRanking',
      'table': 'history'
    };
    return await post(
      baseMainUrl,
      FormData(body),
      decoder: (data) {
        return List<HistoryModel>.from(
            json.decode(data).map((e) => HistoryModel.fromJson(e)));
      },
    ).then((value) => value.body!).catchError((e) => throw e);
  }
}
