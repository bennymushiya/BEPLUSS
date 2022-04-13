//
//  AppDelegate.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotificationsUI
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        requestPushNotification(application: application)
       
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Push Notification
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//
//
//    // if the user doesnt allow us to send them notifications.
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//
//        print("unable to register for remote notification \(error.localizedDescription)")
//    }
//
//    func requestPushNotification() {
//
//        UNUserNotificationCenter.current().delegate = self
//
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in})
//
//    }
                
}


// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        print("DEBUGG: REGISTERED FOR NOTIFICATION WITH DEVICE TOKEN \(deviceToken)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        completionHandler(UIBackgroundFetchResult.newData)
    }
    

    // if the user doesnt allow us to send them notifications.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

        print("DEBUGG: unable to register for remote notification \(error.localizedDescription)")
    }
    
    func requestPushNotification(application: UIApplication) {

        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if let error = error {
                
                print("DEBUGG: failed to ask the ting \(error.localizedDescription)")
                return

            }

            print("DEBUGG: Success in the APNS registry")
        }

        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0

    }
    
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        messaging.token { token, error in
            if let error = error {
                
                print("DEBUGG: failed to token ans that \(error.localizedDescription)")
                return
            }
            
            print("DEBUGG: token \(token)")
        }
        
    }
    
}

