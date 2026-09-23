import UIKit
import Flutter
import GoogleMaps
import google_mobile_ads

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAHLV8p5cjfo6JvaOplpzFhLhbWLULJXHI")
    GeneratedPluginRegistrant.register(with: self)

    // Register ListTileNativeAdFactory.
    let listTileFactory = ListTileNativeAdFactory()
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
      self, factoryId: "listTile", nativeAdFactory: listTileFactory)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
