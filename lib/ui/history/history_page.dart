import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/ui/history/history_controller.dart';

import '../../util/ad_manager_util.dart';
import '../../widgets/list_view_history_all.dart';
import '../../widgets/show_confirmation_dialog.dart';
import '../../widgets/tech_travel_background.dart';

/// 歷史瀏覽紀錄頁面
class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        '確定要刪除全部瀏覽紀錄嗎？',
        onConfirm: (value) => Navigator.of(dialogContext).pop(value),
      ),
    );
    if (confirmed == true) {
      controller.deleteData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF050B1A),
      body: Stack(
        children: [
          const Positioned.fill(child: TechTravelBackground()),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66040D1D),
                    Color(0xAA101342),
                    Color(0xEE050B1A),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                  child: Obx(
                    () => _HistoryHudHeader(
                      count: controller.dataAllList.length,
                    ),
                  ),
                ),
                Obx(
                  () => controller.isADShowing.value &&
                          controller.bannerAd != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width:
                                  controller.bannerAd!.size.width.toDouble(),
                              height:
                                  controller.bannerAd!.size.height.toDouble(),
                              child: AdManagerUtil()
                                  .bannerAdWidget(controller.bannerAd!),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 10),
                Expanded(child: ListViewAllHistory()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => controller.dataAllList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(bottom: 82),
                child: _DeleteHistoryButton(
                  onTap: () => _confirmDeleteAll(context),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _HistoryHudHeader extends StatelessWidget {
  const _HistoryHudHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xD9162940), Color(0xD90C1327)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x6655E6FF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
              BoxShadow(
                color: Color(0x2255E6FF),
                blurRadius: 14,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF55E6FF).withOpacity(0.14),
                  border: Border.all(
                    color: const Color(0xFF55E6FF).withOpacity(0.72),
                  ),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Color(0xFF8CF3FF),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TRAVEL LOG',
                      style: TextStyle(
                        color: Color(0xFFBDF8FF),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '瀏覽紀錄',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'PingFangSC',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B7BFF).withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF9B7BFF).withOpacity(0.55),
                  ),
                ),
                child: Text(
                  '$count 筆',
                  style: const TextStyle(
                    color: Color(0xFFD8CEFF),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'PingFangSC',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteHistoryButton extends StatelessWidget {
  const _DeleteHistoryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '刪除全部瀏覽紀錄',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF8B1A3B), Color(0xFF4A0E2A)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFFF5C8A).withOpacity(0.58),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF5C8A).withOpacity(0.22),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                '清除紀錄',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PingFangSC',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
