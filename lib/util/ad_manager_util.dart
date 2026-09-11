import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManagerUtil {
  static final Map<String, BannerAd> _bannerAds = {};
  static final Map<String, RxBool> _adVisibility = {};

  static void initializeAd(String adUnitId) {
    if (_bannerAds.containsKey(adUnitId)) return;
    final visibility = (_adVisibility[adUnitId] ??= false.obs);
    final ad = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          visibility.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            print('Failed to load a banner ad: ${err.message}');
          }
          ad.dispose();
        },
      ),
    );
    _bannerAds[adUnitId] = ad;
    ad.load();
  }

  static BannerAd? bannerAd(String adUnitId) => _bannerAds[adUnitId];

  static RxBool isADShowing(String adUnitId) =>
      _adVisibility[adUnitId] ??= false.obs;

  static void releaseAd(String adUnitId) {
    _bannerAds.remove(adUnitId)?.dispose();
    _adVisibility[adUnitId]?.value = false;
  }

  Widget bannerAdWidget(BannerAd ad) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        width: ad.size.width.toDouble(),
        height: 100.0,
        alignment: Alignment.center,
        child: AdWidget(ad: ad),
      ),
    );
  }
}
