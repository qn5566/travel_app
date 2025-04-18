import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final Function(bool)? onConfirm;
  String title;

  ConfirmationDialog(this.title, {Key? key, this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: <Widget>[
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!(true);
            }
          },
        ),
        TextButton(
          child: const Text('No'),
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!(false);
            }
          },
        ),
      ],
    );
  }
}
