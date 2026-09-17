import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/mode/data_all.dart';
import '../../data/mode/history_model.dart';
import '../../routes/app_routes.dart';

/// 獨立出來的排行榜單一項目 Widget
class RankingListItem extends StatelessWidget {
  final HistoryModel history;
  final int rankIndex;

  const RankingListItem({
    Key? key,
    required this.history,
    required this.rankIndex,
  }) : super(key: key);

  // 取得對應排名的顏色
  Color _getAvatarColor(int index) {
    const rankColors = [
      Color(0xFFFFD700), // 金
      Color(0xFFC0C0C0), // 銀
      Color(0xFFCD7F32), // 銅
    ];
    return index < 3 ? rankColors[index] : const Color(0xFF49368C);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // 淺灰色背景
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          backgroundColor: _getAvatarColor(rankIndex),
          child: Text(
            '${rankIndex + 1}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white, // 圓圈內的排名數字保持白色
            ),
          ),
        ),
        title: Text(
          history.title ?? '未知景點',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // 👉 修改這裡：強制指定深色文字
          ),
        ),
        subtitle: Text(
          '點擊次數: ${history.value}',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700, // 👉 修改這裡：稍微加深副標題的灰色
          ),
        ),
        onTap: () {
          // 跳轉至 WebView 頁面
          final data = DataAll(name: history.title);
          Get.toNamed(AppRoutes.webViewPage, arguments: data);
        },
      ),
    );
  }
}
