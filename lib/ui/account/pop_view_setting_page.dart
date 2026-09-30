import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/rx_config.dart';
import '../../data/mode/recommend_app_model.dart';
import '../../util/ui_util.dart';
import '../../widgets/network_cache_image.dart';
import 'account_controller.dart';

class PopViewSettingPage extends StatelessWidget {
  final AccountController controller;

  const PopViewSettingPage({super.key, required this.controller});

  void _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _banner({
    required RecommendAppModel item,
    required VoidCallback onTap,
  }) {
    final title = item.title ?? '';
    final subtitle = item.subtitle;
    final image = item.image ?? '';
    final imageHeight = item.imageHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8CF3FF),
              fontWeight: FontWeight.w700,
              fontFamily: "PingFangSC",
              fontSize: 14,
            ),
          ),
        if (subtitle != null && subtitle.trim().isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w400,
              fontFamily: "PingFangSC",
              fontSize: 11,
            ),
          ),
        ],
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
              child: NetworkCacheImage(
                url: image,
                width: double.infinity,
                height: ASize.h(imageHeight),
                fit: BoxFit.cover,
                placeholderWidget: Container(
                  color: const Color(0x22000000),
                  height: ASize.h(imageHeight),
                ),
                errorWidget: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.white38,
                  size: ASize.h(imageHeight) * 0.3,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final recommendApp = Get.find<RxConfig>().recommendApp;
    final platform = defaultTargetPlatform;

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
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < recommendApp.length; i++) ...[
                    if (i > 0) const SizedBox(height: 14),
                    _banner(
                      item: recommendApp[i],
                      onTap: () {
                        final url =
                            recommendApp[i].launchUrlFor(platform: platform);
                        if (url != null && url.isNotEmpty) _launchUrl(url);
                      },
                    ),
                  ],
                ],
              ),
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
