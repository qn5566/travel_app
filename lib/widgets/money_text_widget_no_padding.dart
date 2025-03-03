import 'package:flutter/material.dart';

import '../config/style_info.dart';
import '../util/ui_util.dart';

class MoneyTextWidgetNoPadding extends StatefulWidget {
  String moneyText;

  MoneyTextWidgetNoPadding(this.moneyText, {super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MoneyTextWidgetNoPaddingState();
  }
}

class MoneyTextWidgetNoPaddingState extends State<MoneyTextWidgetNoPadding> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (widget.moneyText.isNotEmpty && widget.moneyText != '0')
        ? Positioned(
            left: 1,
            top: ASize.h(1),
            height: ASize.w(12),
            child: Container(
              decoration: BoxDecoration(
                color: StyleInfo.main_black.withOpacity(0.6),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: ASize.w(6), left: ASize.w(6)),
                    child: Text(
                      widget.moneyText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w100, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
