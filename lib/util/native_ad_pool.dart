import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/AdHelper.dart';

/// 全 App 共用的原生廣告池。
///
/// 避免每個分頁各自載入大量 NativeAd，也避免反覆觸發
/// Google Mobile Ads 的 DynamiteModule 初始化，造成主執行緒卡頓。
class NativeAdPool extends ChangeNotifier {
  NativeAdPool._();

  static final NativeAdPool instance = NativeAdPool._();

  /// 同時載入的原生廣告數量，足以覆蓋畫面上可見的廣告欄位。
  static const int poolSize = 4;

  final List<NativeAd> _ads = [];
  final List<bool> _loaded = [];

  void ensureLoaded() {
    if (_ads.isNotEmpty) return;

    _loaded.addAll(List<bool>.filled(poolSize, false));
    for (var i = 0; i < poolSize; i++) {
      final index = i;
      final ad = NativeAd(
        adUnitId: AdHelper.nativeAdUnitId,
        factoryId: 'listTile',
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            if (index >= _loaded.length) return;
            _loaded[index] = true;
            notifyListeners();
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (kDebugMode) {
              debugPrint(
                'Native ad load failed (code=${error.code} '
                'message=${error.message})',
              );
            }
          },
        ),
      )..load();
      _ads.add(ad);
    }
  }

  /// 依廣告欄位序號取得可重複使用的廣告實例。
  NativeAd? adFor(int slot) {
    ensureLoaded();
    final index = slot % poolSize;
    return index < _ads.length ? _ads[index] : null;
  }

  bool isLoaded(int slot) {
    final index = slot % poolSize;
    return index < _loaded.length && _loaded[index];
  }

  void disposeAll() {
    for (final ad in _ads) {
      ad.dispose();
    }
    _ads.clear();
    _loaded.clear();
  }
}
