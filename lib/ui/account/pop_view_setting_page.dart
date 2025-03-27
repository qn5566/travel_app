import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/style_info.dart';
import '../../util/ui_util.dart';
import 'account_controller.dart';

class PopViewSettingPage extends StatelessWidget {
  final AccountController controller;

  const PopViewSettingPage({super.key, required this.controller});

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius kBorderRadius = BorderRadius.circular(8.0);

    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            '~相關APP產品大推薦~',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Colors.black, fontSize: 20),
          ),
          SizedBox(height: ASize.h(2)),
          const Text(
            'HiMyDream親子台灣旅遊部落客',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: StyleInfo.assistColor),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              onTap: () {
                _launchUrl('https://himydream.me/');
              },
              child: ClipRRect(
                borderRadius: kBorderRadius, // 設置圓角半徑
                child: Image.asset(
                  'images/pics/web_banner.webp',
                  fit: BoxFit.cover,
                  height: ASize.h(50),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          SizedBox(height: ASize.h(2)),
          const Text(
            '台灣吃喝玩樂地圖APP',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: StyleInfo.assistColor),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              onTap: () {
                if (Theme.of(context).platform == TargetPlatform.android) {
                  _launchUrl(
                      'https://play.google.com/store/apps/details?id=com.meetstudio.event');
                } else if (Theme.of(context).platform == TargetPlatform.iOS) {
                  _launchUrl('https://apps.apple.com/us/app/id6446348643');
                }
              },
              child: ClipRRect(
                borderRadius: kBorderRadius, // 設置圓角半徑
                child: Image.asset(
                  'images/setting/setting_banner.webp',
                  fit: BoxFit.cover,
                  height: ASize.h(50),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          SizedBox(height: ASize.h(2)),
          const Text(
            '寵物領養紀錄APP',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: StyleInfo.assistColor),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              onTap: () {
                if (Theme.of(context).platform == TargetPlatform.android) {
                  _launchUrl(
                      'https://play.google.com/store/apps/details?id=com.meetstudio.app.adoptpet');
                } else if (Theme.of(context).platform == TargetPlatform.iOS) {
                  _launchUrl('https://apps.apple.com/us/app/id6737406473');
                }
              },
              child: ClipRRect(
                borderRadius: kBorderRadius, // 設置圓角半徑
                child: Image.asset(
                  'images/pics/app_adoptPet.webp',
                  fit: BoxFit.cover,
                  height: ASize.h(50),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          SizedBox(height: ASize.h(2)),
          const Text(
            '幫忙打分給予支持，大感謝',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: StyleInfo.assistColor),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              onTap: () {
                if (Theme.of(context).platform == TargetPlatform.android) {
                  _launchUrl(
                      'https://play.google.com/store/apps/details?id=com.meetstudio.travel&reviewId=0');
                } else if (Theme.of(context).platform == TargetPlatform.iOS) {
                  _launchUrl(
                      'https://apps.apple.com/us/app/id1671108420?action=write-review');
                }
              },
              child: ClipRRect(
                borderRadius: kBorderRadius, // 設置圓角半徑
                child: Image.asset(
                  'images/setting/rate_us_banner.webp',
                  fit: BoxFit.cover,
                  height: ASize.h(20),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
            child: Divider(
              color: StyleInfo.separatorSettingColor,
              thickness: 1,
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            const Text(
              '開發團隊',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const Text('MeetStudio 工作社', style: TextStyle(color: Colors.black)),
            Text('版本:${controller.getAppVersion()}',
                style: const TextStyle(color: Colors.black)),
            SizedBox(height: ASize.h(2)),
            const Text(
              '資料來源',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const Text('政府資料開放平臺', style: TextStyle(color: Colors.black)),
            SizedBox(height: ASize.h(2)),
          ]),
        ],
      ),
    );
  }
}
