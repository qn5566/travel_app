import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/global_config.dart';
import '../../config/rx_config.dart';
import '../../data/mode/recommend_app_model.dart';
import '../../util/ui_util.dart';
import '../../widgets/network_cache_image.dart';
import 'account_controller.dart';

class PopViewSettingPage extends StatefulWidget {
  final AccountController controller;

  const PopViewSettingPage({super.key, required this.controller});

  @override
  State<PopViewSettingPage> createState() => _PopViewSettingPageState();
}

class _PopViewSettingPageState extends State<PopViewSettingPage> {
  bool _autoUpdate = true;

  @override
  void initState() {
    super.initState();
    _autoUpdate =
        sharedPreferences.getBool(AppConstants.homeAutoUpdateKey) ?? true;
  }

  void _setAutoUpdate(bool value) {
    setState(() => _autoUpdate = value);
    sharedPreferences.setBool(AppConstants.homeAutoUpdateKey, value);
  }

  String get _updateDateLabel {
    final raw = sharedPreferences.getString(AppConstants.homeUpdateShareKey);
    if (raw == null || raw.isEmpty) return '尚未更新';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    String two(int value) => value.toString().padLeft(2, '0');
    return '${parsed.year}/${two(parsed.month)}/${two(parsed.day)} '
        '${two(parsed.hour)}:${two(parsed.minute)}';
  }

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
    final controller = widget.controller;

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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0x1155E6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x3355E6FF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        color: Color(0xFF8CF3FF),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '資料更新日期',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "PingFangSC",
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _updateDateLabel,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontFamily: "PingFangSC",
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.autorenew_rounded,
                        color: Color(0xFF8CF3FF),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '自動更新',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: "PingFangSC",
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '開啟後，資料超過 14 天未更新會自動提醒',
                              style: TextStyle(
                                color: Colors.white54,
                                fontFamily: "PingFangSC",
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _autoUpdate,
                        onChanged: _setAutoUpdate,
                        activeColor: const Color(0xFF55E6FF),
                        activeTrackColor: const Color(0x6655E6FF),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0x0D8CF3FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x3355E6FF)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF19687B), Color(0xFF49368C)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x8C55E6FF)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3355E6FF),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.terminal_rounded,
                      color: Color(0xFF8CF3FF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '開發團隊',
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PingFangSC",
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'MeetStudio 工作社',
                          style: TextStyle(
                            color: Color(0xFF8CF3FF),
                            fontWeight: FontWeight.w800,
                            fontFamily: "PingFangSC",
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '用心打造每一段旅程',
                          style: TextStyle(
                            color: Colors.white54,
                            fontFamily: "PingFangSC",
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0x0D8CF3FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x3355E6FF)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF19687B), Color(0xFF49368C)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x8C55E6FF)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3355E6FF),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.public_rounded,
                      color: Color(0xFF8CF3FF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '資料來源',
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PingFangSC",
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '政府資料開放平臺',
                          style: TextStyle(
                            color: Color(0xFF8CF3FF),
                            fontWeight: FontWeight.w800,
                            fontFamily: "PingFangSC",
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Taiwan Open Data',
                          style: TextStyle(
                            color: Colors.white54,
                            fontFamily: "PingFangSC",
                            fontSize: 11,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0x0D8CF3FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x3355E6FF)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF19687B), Color(0xFF49368C)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x8C55E6FF)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3355E6FF),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.new_releases_rounded,
                      color: Color(0xFF8CF3FF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '版本',
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PingFangSC",
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'v${controller.getAppVersion()}',
                          style: const TextStyle(
                            color: Color(0xFF8CF3FF),
                            fontWeight: FontWeight.w800,
                            fontFamily: "PingFangSC",
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Build ${controller.getAppBuildNumber()}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontFamily: "PingFangSC",
                            fontSize: 11,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
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
