import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/global_config.dart';
import '../../config/rx_config.dart';
import '../../data/mode/recommend_app_model.dart';
import '../../data/repo/data_repo.dart';
import '../../util/ui_util.dart';
import '../../widgets/network_cache_image.dart';
import '../home/home_controller.dart';
import '../map/map_controller.dart';
import 'account_controller.dart';

class PopViewSettingPage extends StatefulWidget {
  final AccountController controller;

  const PopViewSettingPage({super.key, required this.controller});

  @override
  State<PopViewSettingPage> createState() => _PopViewSettingPageState();
}

class _PopViewSettingPageState extends State<PopViewSettingPage> {
  bool _autoUpdate = true;
  bool _manualUpdating = false;
  bool _manualFailed = false;
  double _manualProgress = 0;
  String _manualStatus = '';
  Timer? _manualTicker;

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

  @override
  void dispose() {
    _manualTicker?.cancel();
    super.dispose();
  }

  /// 手動下載最新景點資料，並在原地顯示進度。
  Future<void> _startManualUpdate() async {
    if (_manualUpdating) return;

    setState(() {
      _manualUpdating = true;
      _manualFailed = false;
      _manualStatus = '正在下載景點資料…';
      _manualProgress = 0.1;
    });

    // onProgress 只會回報給第一個發起下載的呼叫端；若與其他頁面共用
    // 下載 future，則用保底 ticker 讓進度條持續前進。
    _manualTicker?.cancel();
    _manualTicker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      if (_manualProgress < 0.8) {
        setState(() {
          _manualProgress = (_manualProgress + 0.01).clamp(0.1, 0.8).toDouble();
        });
      }
    });

    try {
      await Get.find<DataController>().fetchRemoteData(
        onProgress: (value) {
          if (!mounted) return;
          setState(() {
            _manualProgress = value.clamp(0.1, 0.9).toDouble();
          });
        },
      );

      // 即使彈窗已關閉，仍要完成地圖與首頁的記憶體資料刷新。
      if (mounted) {
        setState(() {
          _manualStatus = '正在建立離線資料…';
          _manualProgress = 0.92;
        });
      }
      if (Get.isRegistered<MapController>()) {
        await Get.find<MapController>().fetchDB();
      }
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().fetchDB();
      }
      if (mounted) {
        setState(() {
          _manualProgress = 1;
          _manualStatus = '更新完成';
          _manualFailed = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _manualFailed = true;
          _manualStatus = '下載失敗，請檢查網路後重試';
        });
      }
    } finally {
      _manualTicker?.cancel();
      if (mounted) {
        setState(() => _manualUpdating = false);
      }
    }
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
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _startManualUpdate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _manualUpdating
                              ? const [Color(0xFF2A3550), Color(0xFF232A44)]
                              : const [Color(0xFF19687B), Color(0xFF49368C)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0x8C55E6FF)),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF55E6FF).withValues(alpha: 0.22),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_manualUpdating)
                            const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          else
                            const Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            _manualUpdating ? '更新中…' : '手動更新',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: "PingFangSC",
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_manualStatus.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _manualProgress.clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: const Color(0x2255E6FF),
                        color: _manualFailed
                            ? const Color(0xFFFF5C8A)
                            : const Color(0xFF55E6FF),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _manualStatus,
                            style: TextStyle(
                              color: _manualFailed
                                  ? const Color(0xFFFF9AB8)
                                  : Colors.white70,
                              fontFamily: "PingFangSC",
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Text(
                          '${(_manualProgress * 100).clamp(0, 100).round()}%',
                          style: const TextStyle(
                            color: Color(0xFF8CF3FF),
                            fontWeight: FontWeight.w700,
                            fontFamily: "PingFangSC",
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
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
