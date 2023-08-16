import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
  if UIScreen.main.isCaptured {
      controller.pushRoute("/screenrecordingmessage")
  }
      
    let CHANNEL = FlutterMethodChannel(name: "checkIsScreenRecordingOnIOS", binaryMessenger: controller.binaryMessenger)
    
    CHANNEL.setMethodCallHandler { [unowned self] (methodCall, result) in
        if methodCall.method == "isScreenRecording"
        {
            result(UIScreen.main.isCaptured)
        }
    }

    GeneratedPluginRegistrant.register(with: self)

    NotificationCenter.default.addObserver(
            self,
            selector: #selector(didScreenRecording(_:)),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @objc private func didScreenRecording(_ notification: Notification) {
        //If a screen recording operation is pending then we close the application
        //print(UIScreen.main.isCaptured)

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

        if UIScreen.main.isCaptured {
            controller.pushRoute("/screenrecordingmessage")
        }
    }
}