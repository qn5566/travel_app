import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/ui/history/history_controller.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../config/global_config.dart';
import '../data/mode/data_all.dart';
import 'comment_error.dart';

class ListViewAllHistory extends StatelessWidget {
  final HistoryController controller = Get.find<HistoryController>();

  ListViewAllHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xD9162940), Color(0xD90C1327)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x4455E6FF)),
              boxShadow: const [
                BoxShadow(color: Color(0x2255E6FF), blurRadius: 20),
              ],
            ),
            child: Lottie.asset('assets/loading.json'),
          ),
        );
      }

      if (controller.dataAllList.isEmpty) {
        return const _HistoryEmptyState();
      }

      return RefreshIndicator(
        color: const Color(0xFF55E6FF),
        backgroundColor: const Color(0xFF101C32),
        onRefresh: controller.initData,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 2, 14, 190),
          itemCount: controller.dataAllList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = controller.dataAllList[index];
            return _HistoryHudCard(
              item: item,
              index: index,
              onTap: () => controller.onTapDataAll(item),
            );
          },
        ),
      );
    });
  }
}

class _HistoryHudCard extends StatelessWidget {
  const _HistoryHudCard({
    required this.item,
    required this.index,
    required this.onTap,
  });

  final DataAll item;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final region = (item.region ?? '').trim();
    final town = (item.town ?? '').trim();
    final streetAddress = (item.address ?? '').trim();
    final locationParts = <String>[
      if (region.isNotEmpty && region != '0') region,
      if (town.isNotEmpty && town != '0' && town != region) town,
      if (streetAddress.isNotEmpty && streetAddress != '0') streetAddress,
    ];
    final locationText = locationParts.isEmpty ? '地址未提供' : locationParts.join('');
    final sequence = (index + 1).toString().padLeft(3, '0');

    return Semantics(
      button: true,
      label: '開啟 ${item.name ?? '景點'} 詳細資料',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xE6122035), Color(0xE60B1026)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x4455E6FF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
              BoxShadow(color: Color(0x1855E6FF), blurRadius: 12),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.7777777,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    VideoCoverView(
                      cover: item.picture1 ?? '',
                      money: item.region,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x33000000),
                            Colors.transparent,
                            Color(0xCC050B1A),
                          ],
                          stops: [0, 0.52, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 11,
                      top: 11,
                      child: _HudChip(
                        icon: Icons.history_rounded,
                        text: 'NO.$sequence',
                      ),
                    ),
                    if (region.isNotEmpty && region != '0')
                      Positioned(
                        right: 11,
                        top: 11,
                        child: _HudChip(
                          icon: Icons.radar_rounded,
                          text: region,
                          purple: true,
                        ),
                      ),
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 12,
                      child: Text(
                        item.name ?? emptyData,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'PingFangSC',
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 11, 12, 13),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF55E6FF),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xAA55E6FF),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.place_outlined,
                      color: Color(0xFF8CF3FF),
                      size: 19,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        locationText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.72),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PingFangSC',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF9B7BFF),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({
    required this.icon,
    required this.text,
    this.purple = false,
  });

  final IconData icon;
  final String text;
  final bool purple;

  @override
  Widget build(BuildContext context) {
    final accent =
        purple ? const Color(0xFFB8A4FF) : const Color(0xFF8CF3FF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xD90B1426),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withOpacity(0.62)),
        boxShadow: [
          BoxShadow(color: accent.withOpacity(0.16), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 13),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: purple ? 0.4 : 1.0,
              fontFamily: 'PingFangSC',
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 34),
              padding: const EdgeInsets.fromLTRB(28, 26, 28, 22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xD9162940), Color(0xD90C1327)],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0x4455E6FF)),
                boxShadow: const [
                  BoxShadow(color: Color(0x2255E6FF), blurRadius: 18),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 110,
                    height: 112,
                    child: CommentError(
                      textColor: Color(0xFFBDF8FF),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '尚無瀏覽紀錄',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'PingFangSC',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '查看景點後，足跡會記錄在這裡',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.58),
                      fontSize: 12,
                      fontFamily: 'PingFangSC',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
