import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Widget _banner({
    required String title,
    required String image,
    required VoidCallback onTap,
    double imageHeight = 50,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF8CF3FF),
            fontWeight: FontWeight.w700,
            fontFamily: "PingFangSC",
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x6655E6FF)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                height: ASize.h(imageHeight),
                width: double.infinity,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.88,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF162940), Color(0xFF0C1327)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x6655E6FF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.widgets_rounded, color: Color(0xFF55E6FF), size: 22),
                SizedBox(width: 8),
                Text(
                  '相關APP產品大推薦',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: "PingFangSC",
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _banner(
              title: 'HiMyDream親子台灣旅遊部落客',
              image: 'images/pics/web_banner.webp',
              onTap: () => _launchUrl('https://himydream.me/'),
            ),
            const SizedBox(height: 14),
            _banner(
              title: '台灣吃喝玩樂地圖APP',
              image: 'images/setting/setting_banner.webp',
              onTap: () {
                if (Theme.of(context).platform == TargetPlatform.android) {
                  _launchUrl(
                      'https://play.google.com/store/apps/details?id=com.meetstudio.event');
                } else if (Theme.of(context).platform == TargetPlatform.iOS) {
                  _launchUrl('https://apps.apple.com/us/app/id6446348643');
                }
              },
            ),
            const SizedBox(height: 14),
            _banner(
              title: '寵物領養紀錄APP',
              image: 'images/pics/app_adoptPet.webp',
              onTap: () {
                if (Theme.of(context).platform == TargetPlatform.android) {
                  _launchUrl(
                      'https://play.google.com/store/apps/details?id=com.meetstudio.app.adoptpet');
                } else if (Theme.of(context).platform == TargetPlatform.iOS) {
                  _launchUrl('https://apps.apple.com/us/app/id6737406473');
                }
              },
            ),
            const SizedBox(height: 14),
            _banner(
              title: '幫忙打分給予支持，大感謝',
              image: 'images/setting/rate_us_banner.webp',
              imageHeight: 20,
              onTap: () {
                if (Theme.of(context).platform == TargetPlatform.android) {
                  _launchUrl(
                      'https://play.google.com/store/apps/details?id=com.meetstudio.travel&reviewId=0');
                } else if (Theme.of(context).platform == TargetPlatform.iOS) {
                  _launchUrl(
                      'https://apps.apple.com/us/app/id1671108420?action=write-review');
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                color: Color(0x4455E6FF),
                thickness: 1,
              ),
            ),
            const Center(
              child: Column(
                children: [
                  Text(
                    '開發團隊',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PingFangSC",
                    ),
                  ),
                  Text(
                    'MeetStudio 工作社',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: "PingFangSC",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '版本:${controller.getAppVersion()}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: "PingFangSC",
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Column(
                children: [
                  Text(
                    '資料來源',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PingFangSC",
                    ),
                  ),
                  Text(
                    '政府資料開放平臺',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: "PingFangSC",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
