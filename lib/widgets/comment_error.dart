import 'package:flutter/material.dart';

/// 錯誤顯示的View
class CommentError extends StatelessWidget {
  const CommentError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'images/icon/no_data_white.webp',
          fit: BoxFit.fill,
          width: 64,
          height: 64,
        ),
        const Text('無資料',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
