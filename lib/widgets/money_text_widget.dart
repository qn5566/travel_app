import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/style_info.dart';
import '../util/ui_util.dart';

class MoneytextWidget extends StatefulWidget {
  String moneyText;

  MoneytextWidget(this.moneyText, {super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MoneytextWidgetState();
  }
}

class MoneytextWidgetState extends State<MoneytextWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (widget.moneyText.isNotEmpty && widget.moneyText != '0')
        ? Positioned(
            left: ASize.w(5),
            top: ASize.w(5),
            height: ASize.w(12),
            child: Container(
              decoration: BoxDecoration(
                color: StyleInfo.main_black.withOpacity(0.6),
                borderRadius: BorderRadius.all(Radius.circular(ASize.w(10))),
              ),
              child: Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: ASize.w(3), right: ASize.w(3)),
                    child: const Icon(
                      Icons.travel_explore,
                      color: Colors.orange,
                    ),
                    // Image.asset(
                    //   'images/icon/img.png',
                    //   width: ASize.w(8),
                    // ),
                  ),
                  Text(
                    widget.moneyText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w100, color: Colors.white),
                  ),
                  Padding(padding: EdgeInsets.only(right: ASize.w(6))),
                ],
              ),
            ),
          )
        : Container();
  }
}
