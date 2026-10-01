import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/ui/want/want_controller.dart';
import 'package:travel/widgets/money_text_widget_no_padding.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../data/mode/data_all.dart';
import 'tech_loading_view.dart';

class GridViewAllHistory extends StatelessWidget {
  final WantController controller = Get.find<WantController>();

  GridViewAllHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const TechLoadingView()
          : (controller.dataAllList.isNotEmpty)
              ? MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: RefreshIndicator(
                    color: const Color(0xFF55E6FF),
                    backgroundColor: const Color(0xFF0C1327),
                    onRefresh: () async {
                      controller.reload();
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 120),
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: controller.dataAllList.length,
                      itemBuilder: (context, index) {
                        DataAll item = controller.dataAllList[index];
                        return _buildCard(item);
                      },
                    ),
                  ),
                )
              : _buildEmptyState(),
    );
  }

  Widget _buildCard(DataAll item) {
    return GestureDetector(
      onTap: () {
        controller.onTapDataAll(item);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xD9162940), Color(0xD90C1327)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x6655E6FF)),
          boxShadow: [
            const BoxShadow(
              color: Color(0x44000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xFF55E6FF).withValues(alpha: 0.10),
              blurRadius: 14,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: VideoCoverView(
                  cover: item.picture1 ?? '',
                  money: item.region,
                ),
              ),
            ),
            MoneyTextWidgetNoPadding(item.region ?? '尚未資料'),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x3355E6FF)),
                ),
                child: Text(
                  item.name!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PingFangSC',
                    fontSize: 11,
                    shadows: [
                      Shadow(color: Colors.black87, blurRadius: 2),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 56,
            color: const Color(0xFF55E6FF).withValues(alpha: 0.45),
          ),
          const SizedBox(height: 14),
          const Text(
            '還沒有想去的地方',
            style: TextStyle(
              color: Color(0xFFEAF3FF),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'PingFangSC',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '去首頁收藏喜歡的景點吧',
            style: TextStyle(
              color: Color(0xFF8FA3B8),
              fontSize: 13,
              fontFamily: 'PingFangSC',
            ),
          ),
        ],
      ),
    );
  }
}
