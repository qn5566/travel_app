import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final Function(bool)? onConfirm;
  String title;

  ConfirmationDialog(this.title, {Key? key, this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0C1327),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x6655E6FF)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: "PingFangSC",
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            '取消',
            style: TextStyle(color: Color(0xFF8CF3FF)),
          ),
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!(false);
            }
          },
        ),
        TextButton(
          child: const Text(
            '確定',
            style: TextStyle(color: Color(0xFFFF5C8A)),
          ),
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!(true);
            }
          },
        ),
      ],
    );
  }
}
