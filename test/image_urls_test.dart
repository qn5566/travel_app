// DataAll.imageUrls 單元測試：
// 驗證新版 ZIP 資料（rawJson 內含 Images 陣列）可解析出全部圖片，
// 舊資料 / 解析失敗時回退 picture1~3。
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:travel/data/mode/data_all.dart';

void main() {
  group('DataAll.imageUrls', () {
    test('rawJson 有 5 張圖片時回傳全部 5 個 URL', () {
      final rawJson = jsonEncode({
        'AttractionID': 'C1_123',
        'AttractionName': '測試景點',
        'Images': [
          {'URL': 'https://example.com/1.jpg', 'Description': '第一張'},
          {'URL': 'https://example.com/2.jpg', 'Description': '第二張'},
          {'URL': 'https://example.com/3.jpg', 'Description': '第三張'},
          {'URL': 'https://example.com/4.jpg', 'Description': '第四張'},
          {'URL': 'https://example.com/5.jpg', 'Description': '第五張'},
        ],
      });
      final data = DataAll(
        id: 'C1_123',
        picture1: 'https://example.com/1.jpg',
        rawJson: rawJson,
      );

      final urls = data.imageUrls;

      expect(urls.length, 5);
      expect(urls[0], 'https://example.com/1.jpg');
      expect(urls[4], 'https://example.com/5.jpg');
    });

    test('rawJson 為舊格式（無 Images）時回退 picture1~3', () {
      final rawJson = jsonEncode({
        'Id': 'old_1',
        'Name': '舊景點',
      });
      final data = DataAll(
        id: 'old_1',
        picture1: 'https://example.com/a.jpg',
        picture2: 'https://example.com/b.jpg',
        picture3: 'https://example.com/c.jpg',
        rawJson: rawJson,
      );

      final urls = data.imageUrls;

      expect(urls, [
        'https://example.com/a.jpg',
        'https://example.com/b.jpg',
        'https://example.com/c.jpg',
      ]);
    });

    test('rawJson 解析失敗（非法 JSON）時回退 picture1~3', () {
      final data = DataAll(
        id: 'x_1',
        picture1: 'https://example.com/a.jpg',
        picture2: 'https://example.com/b.jpg',
        rawJson: '{這不是合法的 JSON',
      );

      final urls = data.imageUrls;

      expect(urls, [
        'https://example.com/a.jpg',
        'https://example.com/b.jpg',
      ]);
    });

    test('圖片 URL 為空字串時會被過濾掉', () {
      final rawJson = jsonEncode({
        'AttractionID': 'C1_456',
        'Images': [
          {'URL': 'https://example.com/1.jpg', 'Description': 'ok'},
          {'URL': '', 'Description': '空 URL'},
          {'URL': '   ', 'Description': '空白 URL'},
          {'Description': '沒有 URL'},
          {'URL': 'https://example.com/2.jpg', 'Description': 'ok'},
        ],
      });
      final data = DataAll(id: 'C1_456', rawJson: rawJson);

      final urls = data.imageUrls;

      expect(urls, [
        'https://example.com/1.jpg',
        'https://example.com/2.jpg',
      ]);
    });

    test('只有 picture1 時回傳 1 張', () {
      final data = DataAll(
        id: 'p_1',
        picture1: 'https://example.com/only.jpg',
      );

      final urls = data.imageUrls;

      expect(urls, ['https://example.com/only.jpg']);
    });

    test('完全沒有圖片時回傳空 list', () {
      final data = DataAll(id: 'none_1');

      expect(data.imageUrls, isEmpty);
    });

    test('fromAttractionJson 產生的資料可透過 imageUrls 取得全部圖片', () {
      // 模擬 api_helper 解析 AttractionList.json 單筆景點的路徑
      final attractionJson = {
        'AttractionID': 'C1_789',
        'AttractionName': '風景區',
        'Images': [
          {'URL': 'https://example.com/x1.jpg'},
          {'URL': 'https://example.com/x2.jpg'},
          {'URL': 'https://example.com/x3.jpg'},
          {'URL': 'https://example.com/x4.jpg'},
        ],
      };
      final data = DataAll.fromAttractionJson(attractionJson);

      expect(data.picture1, 'https://example.com/x1.jpg');
      expect(data.imageUrls.length, 4);
      expect(data.imageUrls[3], 'https://example.com/x4.jpg');
    });
  });
}
