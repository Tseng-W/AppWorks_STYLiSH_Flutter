import Flutter
import TPDirect
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let appID: Int32 = 123456
        TPDSetup.setWithAppId(appID, withAppKey: "APP_KEY", with: TPDServerType.sandBox)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
