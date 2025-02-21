import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManagerUtil {
  static BannerAd? _bannerAd;
  static var isADShowing = false.obs;

  static void initializeAd(String adUnitId) {
    _bannerAd ??= BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isADShowing(true);
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            print('Failed to load a banner ad: ${err.message}');
          }
          ad.dispose();
        },
      ),
    )..load();
  }

  static BannerAd? get bannerAd => _bannerAd;

  Widget bannerAdWidget() {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        width: _bannerAd?.size.width.toDouble(),
        height: 100.0,
        alignment: Alignment.center,
        child: _bannerAd != null ? AdWidget(ad: _bannerAd!) : Container(),
      ),
    );
  }
}
