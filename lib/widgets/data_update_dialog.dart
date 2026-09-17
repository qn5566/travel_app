import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 資料更新彈窗的階段
enum DataUpdatePhase {
  /// 詢問是否更新
  asking,

  /// 下載中
  downloading,

  /// 完成（短暫顯示後自動關閉）
  done,

  /// 失敗（可重試）
  failed,
}

/// 「資料已兩週未更新」提醒彈窗。
///
/// 依 [phase] 切換詢問 / 下載進度（樣式取自 TechDownloadProgress）/
/// 完成 / 失敗四種外觀。所有狀態由外部（DashboardController）以 Rx 注入，
/// 此 widget 不依賴任何 controller。
class DataUpdateDialog extends StatelessWidget {
  const DataUpdateDialog({
    super.key,
    required this.phase,
    required this.progress,
    required this.status,
    required this.onConfirm,
    required this.onDismiss,
    required this.onRetry,
  });

  final Rx<DataUpdatePhase> phase;
  final RxDouble progress;
  final RxString status;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;
  final VoidCallback onRetry;

  static const Color _accent = Color(0xFF55E6FF);
  static const Color _danger = Color(0xFFFF5C8A);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 下載中 / 完成時不允許返回鍵關閉，避免 Get.back() 誤關主頁面
      onWillPop: () async {
        final current = phase.value;
        return current == DataUpdatePhase.asking ||
            current == DataUpdatePhase.failed;
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        child: Obx(() => _buildCard(context, phase.value)),
      ),
    );
  }

  Widget _buildCard(BuildContext context, DataUpdatePhase current) {
    final accent = current == DataUpdatePhase.failed ? _danger : _accent;
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      decoration: BoxDecoration(
        color: const Color(0xDD081522),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: accent.withOpacity(0.55)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.18),
            blurRadius: 34,
            spreadRadius: 2,
          ),
        ],
      ),
      child: switch (current) {
        DataUpdatePhase.asking => _buildAsking(),
        DataUpdatePhase.downloading => _buildProgress(current, accent),
        DataUpdatePhase.done => _buildProgress(current, accent),
        DataUpdatePhase.failed => _buildFailed(accent),
      },
    );
  }

  // ---------------- 詢問階段 ----------------

  Widget _buildAsking() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.update_rounded, color: _accent, size: 21),
            const SizedBox(width: 9),
            Text(
              'DATA SYNC',
              style: TextStyle(
                color: _accent,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.4,
                fontFamily: "PingFangSC",
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          '資料已經有 2 個禮拜沒有更新，\n是否要更新資料呢？',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.6,
            fontFamily: "PingFangSC",
          ),
        ),
        const SizedBox(height: 24),
        // 好：漸層填色主按鈕
        SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF19687B), Color(0xFF49368C)],
              ),
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: _accent.withOpacity(0.25),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: TextButton(
              onPressed: onConfirm,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                '好',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: "PingFangSC",
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // 不用：外框次要按鈕
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onDismiss,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: BorderSide(color: Colors.white.withOpacity(0.25)),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: const Text(
              '不用',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: "PingFangSC",
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- 下載 / 完成階段 ----------------

  Widget _buildProgress(DataUpdatePhase current, Color accent) {
    final value = progress.value.clamp(0.0, 1.0).toDouble();
    final percent = (value * 100).round();
    final isDone = current == DataUpdatePhase.done;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.radar_rounded, color: accent, size: 21),
            const SizedBox(width: 9),
            Text(
              'DATA SYNC',
              style: TextStyle(
                color: accent,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.4,
                fontFamily: "PingFangSC",
              ),
            ),
            const Spacer(),
            Text(
              '01 / 01',
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 11,
                letterSpacing: 1.2,
                fontFamily: "PingFangSC",
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 132,
          width: 132,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 118,
                width: 118,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 7,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.white.withOpacity(0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      fontFamily: "PingFangSC",
                    ),
                  ),
                  Text(
                    isDone ? 'READY' : 'DOWNLOADING',
                    style: TextStyle(
                      color: accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.8,
                      fontFamily: "PingFangSC",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          isDone ? '更新完成！' : status.value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: "PingFangSC",
          ),
        ),
        const SizedBox(height: 15),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                height: 8,
                color: Colors.white.withOpacity(0.09),
              ),
              FractionallySizedBox(
                widthFactor: value,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, const Color(0xFF9B7BFF)],
                    ),
                    boxShadow: [
                      BoxShadow(color: accent, blurRadius: 9),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- 失敗階段 ----------------

  Widget _buildFailed(Color accent) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.cloud_off_rounded, color: accent, size: 21),
            const SizedBox(width: 9),
            Text(
              'CONNECTION LOST',
              style: TextStyle(
                color: accent,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.4,
                fontFamily: "PingFangSC",
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          status.value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.6,
            fontFamily: "PingFangSC",
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text(
              '重試',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: "PingFangSC",
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: accent,
              side: BorderSide(color: accent.withOpacity(0.7)),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onDismiss,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: BorderSide(color: Colors.white.withOpacity(0.25)),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: const Text(
              '關閉',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: "PingFangSC",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
