import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../config/style_info.dart';
import '../ui/detail/detail_controller.dart';
import '../util/ToastUtil.dart';
import '../util/ui_util.dart';
import 'tech_detail_widgets.dart';

class InfoView extends StatelessWidget {
  InfoView({Key? key}) : super(key: key);
  final DetailController controller = Get.find<DetailController>();

  @override
  Widget build(BuildContext context) {
    final item = controller.item;
    if (item == null) return const SizedBox.shrink();

    return Container(
      color: StyleInfo.infoBGColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            top: ASize.w(5), left: ASize.w(5), right: ASize.w(5), bottom: ASize.h(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 官方網站
            if (item.website != null && item.website!.isNotEmpty)
              InfoCard(
                icon: Icons.language_rounded,
                title: '官方網站',
                onTap: () => controller.call(Uri.parse(item.website!)),
                child: const InfoText('點此前往官方網站', isLink: true),
              ),

            // 聯絡電話
            InfoCard(
              icon: Icons.phone_rounded,
              title: '聯絡電話',
              iconColor: const Color(0xFF19687B),
              onTap: () => controller.call(
                  Uri(scheme: 'tel', path: "+${item.tel}")),
              child: InfoText(item.tel?.isNotEmpty == true
                  ? item.tel!
                  : '暫時無資料'),
            ),

            // 地址資訊
            if (item.address != null && item.address!.isNotEmpty)
              InfoCard(
                icon: Icons.location_on_rounded,
                title: '地址資訊',
                iconColor: const Color(0xFFE07B1A),
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: item.address ?? '暫時無資料'));
                  ToastUtil.info(context, "複製成功!");
                },
                child: InfoText(item.address!),
              ),

            // 開啟導航
            InfoCard(
              icon: Icons.assistant_navigation,
              title: '開啟導航',
              iconColor: const Color(0xFF19687B),
              onTap: () {
                controller.call(Uri(
                    scheme: 'https',
                    host: 'www.google.com',
                    path:
                        '/maps/search/${(item.address != null && item.address!.isNotEmpty) ? item.address : item.name}'));
              },
              child: const Row(
                children: [
                  Icon(Icons.directions_rounded,
                      color: Color(0xFF19687B), size: 16),
                  SizedBox(width: 4),
                  InfoText('點此開啟 Google Maps 導航', isLink: true),
                ],
              ),
            ),

            // 營業時間
            if (item.opentime?.isNotEmpty == true)
              InfoCard(
                icon: Icons.access_time_rounded,
                title: '營業時間',
                iconColor: const Color(0xFF49368C),
                child: InfoText(item.opentime ?? ''),
              ),

            // 門票
            if (item.ticketinfo != null && item.ticketinfo!.isNotEmpty)
              InfoCard(
                icon: Icons.confirmation_number_rounded,
                title: '門票',
                iconColor: const Color(0xFFE07B1A),
                child: InfoText(item.ticketinfo!),
              ),

            // 旅遊資訊
            if (item.travellinginfo != null && item.travellinginfo!.isNotEmpty)
              InfoCard(
                icon: Icons.directions_bus_rounded,
                title: '旅遊資訊',
                iconColor: const Color(0xFF19687B),
                child: InfoText(item.travellinginfo!),
              ),

            // 詳細資訊 — fix: description takes priority, then toldescribe
            Builder(builder: (_) {
              final detail = item.description?.isNotEmpty == true
                  ? item.description
                  : item.toldescribe?.isNotEmpty == true
                      ? item.toldescribe
                      : null;
              if (detail == null) return const SizedBox.shrink();
              return InfoCard(
                icon: Icons.info_outline_rounded,
                title: '詳細資訊',
                iconColor: const Color(0xFF49368C),
                child: InfoText(detail),
              );
            }),

            // 注意事項
            if (item.remarks != null && item.remarks!.isNotEmpty)
              InfoCard(
                icon: Icons.warning_amber_rounded,
                title: '注意事項',
                iconColor: const Color(0xFFD97706),
                child: InfoText(item.remarks!),
              ),

            // 更新時間
            if (item.changetime != null && item.changetime!.isNotEmpty)
              InfoCard(
                icon: Icons.update_rounded,
                title: '更新時間',
                iconColor: const Color(0xFF7C7C8D),
                child: InfoText(item.changetime ?? ''),
              ),
          ],
        ),
      ),
    );
  }
}
