//
//  ListTileNativeAdFactory.swift
//  Runner
//
//  Created by Ted Hsu on 2024/9/6.
//

import google_mobile_ads

final class ListTileNativeAdFactory: NSObject, FLTNativeAdFactory {
    func createNativeAd(
        _ nativeAd: GADNativeAd,
        customOptions: [AnyHashable: Any]? = nil
    ) -> GADNativeAdView? {
        guard
            let nibView = Bundle.main.loadNibNamed(
                "ListTileNativeAdView",
                owner: nil,
                options: nil
            )?.first,
            let nativeAdView = nibView as? GADNativeAdView,
            let headlineView = nativeAdView.headlineView as? UILabel,
            let bodyView = nativeAdView.bodyView as? UILabel,
            let iconView = nativeAdView.iconView as? UIImageView
        else {
            NSLog("Unable to load ListTileNativeAdView or its required outlets.")
            return nil
        }

        headlineView.text = nativeAd.headline

        bodyView.text = nativeAd.body
        bodyView.isHidden = nativeAd.body == nil

        iconView.image = nativeAd.icon?.image
        iconView.isHidden = nativeAd.icon == nil

        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        nativeAdView.nativeAd = nativeAd

        return nativeAdView
    }
}

