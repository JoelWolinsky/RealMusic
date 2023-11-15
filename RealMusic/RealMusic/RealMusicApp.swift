//
//  RealMusicApp.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 03/10/2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import WebKit
import UserNotifications
import Firebase
import FirebaseMessaging


@main
struct RealMusicApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        //FirebaseApp.configure()
    }
    

    var body: some Scene {
        WindowGroup {
            let viewModel = SignInViewModel()
            //let webview = WebView()
            //viewModel.getAccessTokenFromView()
            ContentView()
                .environmentObject(viewModel)
                
        }
        
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
}

extension AppDelegate: MessagingDelegate {
    internal func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        
        
        if UserDefaults.standard.value(forKey: "uid") != nil && UserDefaults.standard.value(forKey: "username") != nil {
            let deviceToken:[String: String] = ["token": fcmToken ?? "", "username": UserDefaults.standard.value(forKey: "username") as! String, "uid" : UserDefaults.standard.value(forKey: "uid") as! String]
            
            UserDefaults.standard.set(deviceToken, forKey: "deviceToken")

            
            let db = Firestore.firestore()
            //let post = Post(title: "Test Send Post", uid: "test uid")

            do {
                try db.collection("DeviceTokens").document(UserDefaults.standard.value(forKey: "uid") as! String).setData(from: deviceToken)
                print("Device Token added")
            } catch let error {
                print("Error writing city to Firestore: \(error)")
            }
            print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
        }
        //
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)

    completionHandler()
  }
}
