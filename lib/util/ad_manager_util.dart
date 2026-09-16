import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManagerUtil {
  static final Map<String, BannerAd> _bannerAds = {};
  static final Map<String, RxBool> _adVisibility = {};

  static void initializeAd(String adUnitId, {String? placementId}) {
    final key = placementId ?? adUnitId;
    if (_bannerAds.containsKey(key)) return;
    final visibility = (_adVisibility[key] ??= false.obs);
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
    _bannerAds[key] = ad;
    ad.load();
  }

  static BannerAd? bannerAd(String adUnitId, {String? placementId}) =>
      _bannerAds[placementId ?? adUnitId];

  static RxBool isADShowing(String adUnitId, {String? placementId}) =>
      _adVisibility[placementId ?? adUnitId] ??= false.obs;

  static void releaseAd(String adUnitId, {String? placementId}) {
    final key = placementId ?? adUnitId;
    _bannerAds.remove(key)?.dispose();
    _adVisibility[key]?.value = false;
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
