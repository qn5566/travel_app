import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/widgets/money_text_widget_no_padding.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../config/global_config.dart';
import '../config/rx_config.dart';
import '../data/mode/data_all.dart';
import '../ui/home/home_controller.dart';
import '../util/native_ad_pool.dart';
import 'comment_error.dart';
import 'tech_loading_view.dart';

class GridViewHome extends StatefulWidget {
  const GridViewHome({Key? key, required this.site, this.callback})
      : super(key: key);

  final String site;
  final VoidCallback? callback;

  @override
  State<GridViewHome> createState() => _GridViewHomeState();
}

class _GridViewHomeState extends State<GridViewHome> {
  static const _kAdIndex = 5;

  final HomeController controller = Get.find<HomeController>();
  final RxConfig userData = Get.find();

  @override
  void initState() {
    super.initState();
    controller.loadRegion(widget.site);
    if (canPlayAD()) {
      NativeAdPool.instance.addListener(_onNativeAdsChanged);
      NativeAdPool.instance.ensureLoaded();
    }
  }

  @override
  void dispose() {
    NativeAdPool.instance.removeListener(_onNativeAdsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final dataList = controller.regionData(widget.site);
        return controller.firstLoading.value
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/car.json'),
                  const Text(
                    '第一次下載會比較久請稍等..',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            : controller.regionLoading(widget.site).value
                ? const TechLoadingView()
                : (dataList.isNotEmpty)
                    ? MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 120),
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: _getItemTotalCount(dataList),
                          itemBuilder: (context, index) {
                            if (canPlayAD() &&
                                index % _kAdIndex == 0 &&
                                index != 0) {
                              final adIndex = (index ~/ _kAdIndex) - 1;
                              if (NativeAdPool.instance.isLoaded(adIndex)) {
                                final ad = NativeAdPool.instance.adFor(adIndex);
                                if (ad != null) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: AdWidget(ad: ad),
                                  );
                                }
                              }
                              return Container(
                                alignment: Alignment.center,
                                child: const TechLoadingView(compact: true),
                              );
                            }

                            final item =
                                dataList[_getDestinationItemIndex(index)];
                            return _buildDataItem(item);
                          },
                        ),
                      )
                    : const CommentError();
      },
    );
  }

  Widget _buildDataItem(DataAll item) {
    return GestureDetector(
      onTap: () {
        controller.onTap(item);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xD9162940), Color(0xD90C1327)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x6655E6FF)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x44000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: VideoCoverView(
                    cover: item.picture1 ?? '',
                    money: item.region,
                  ),
                ),
              ),
            ),
            MoneyTextWidgetNoPadding(item.region ?? '尚未資料'),
            Positioned(
              left: 4,
              right: 4,
              bottom: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.name!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PingFangSC',
                    fontSize: 11,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        blurRadius: 2,
                      ),
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

  int _getItemTotalCount(List<DataAll> dataList) {
    final dataLength = dataList.length;
    if (canPlayAD() && dataLength > _kAdIndex) {
      return dataLength + (dataLength ~/ _kAdIndex);
    }
    return dataLength;
  }

  /// 取得景點資料索引
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && canPlayAD()) {
      return rawIndex - (rawIndex ~/ _kAdIndex);
    }
    return rawIndex;
  }

  /// 是否可以播放廣告
  bool canPlayAD() => adSwitch == '1';

  void _onNativeAdsChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}
