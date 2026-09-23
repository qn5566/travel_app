import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../config/AdHelper.dart';
import '../config/global_config.dart';
import '../config/rx_config.dart';
import '../data/mode/data_all.dart';
import '../ui/home/home_controller.dart';
import '../util/ui_util.dart';
import 'comment_error.dart';

class GridViewHome extends StatefulWidget {
  const GridViewHome({Key? key, required this.site, this.callback})
      : super(key: key);

  final String site;
  final VoidCallback? callback;

  @override
  State<GridViewHome> createState() => _GridViewHomeState();
}

class _GridViewHomeState extends State<GridViewHome> {
  static const _kAdIndex = 13;
  static const _requiredAds = 10;

  final HomeController controller = Get.find<HomeController>();
  final RxConfig userData = Get.find();
  final List<NativeAd> _ads = [];
  final List<bool> _adLoaded = [];

  @override
  void initState() {
    super.initState();
    if (canPlayAD()) {
      _loadNativeAds();
    }
  }

  @override
  void dispose() {
    for (final ad in _ads) {
      ad.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.firstLoading.value
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
          : controller.isLoading.value
              ? Lottie.asset('assets/loading.json')
              : (controller.dataList.isNotEmpty)
                  ? MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          controller.updateData();
                        },
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 3 列
                            childAspectRatio: 0.75, // 調整子項目比例
                          ),
                          itemCount: _getItemTotalCount(),
                          itemBuilder: (context, index) {
                            if (canPlayAD() &&
                                index % _kAdIndex == 0 &&
                                index != 0) {
                              final adIndex = (index ~/ _kAdIndex) - 1;
                              if (adIndex >= 0 &&
                                  adIndex < _ads.length &&
                                  _adLoaded[adIndex]) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: AdWidget(ad: _ads[adIndex]),
                                );
                              }
                              return Container(
                                alignment: Alignment.center,
                                child: Lottie.asset('assets/loading.json'),
                              );
                            }

                            final item = controller
                                .dataList[_getDestinationItemIndex(index)];
                            return _buildDataItem(item);
                          },
                        ),
                      ),
                    )
                  : const CommentError(),
    );
  }

  Widget _buildDataItem(DataAll item) {
    return GestureDetector(
      onTap: () {
        controller.onTap(item);
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: VideoCoverView(
                cover: item.picture1 ?? '',
                money: item.region,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Text(
                      item.name!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'PingFangSC',
                        fontStyle: FontStyle.normal,
                        fontSize: ASize.ft(6),
                        shadows: const [
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getItemTotalCount() {
    final dataLength = controller.dataList.length;
    if (canPlayAD() && dataLength > _kAdIndex) {
      return dataLength + (dataLength ~/ _kAdIndex);
    }
    return dataLength;
  }

  /// 加載廣告
  void _loadNativeAds() {
    if (_ads.isNotEmpty) return;

    _adLoaded.addAll(List<bool>.filled(_requiredAds, false));

    for (int i = 0; i < _requiredAds; i++) {
      final ad = NativeAd(
        adUnitId: AdHelper.nativeAdUnitId,
        factoryId: 'listTile',
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            if (!mounted) return;
            setState(() {
              _adLoaded[i] = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            debugPrint(
              'Ad load failed (code=${error.code} message=${error.message})',
            );
          },
        ),
      )..load();
      _ads.add(ad);
    }
  }

  /// 取得景點資料索引
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && canPlayAD()) {
      return rawIndex - (rawIndex ~/ _kAdIndex);
    }
    return rawIndex;
  }

  /// 是否可以播放廣告
  bool canPlayAD() {
    final enabled = adSwitch == '1';
    debugPrint('GridViewHome nativeAdEnabled: $enabled');
    return enabled;
  }
}
