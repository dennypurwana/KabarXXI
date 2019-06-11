//
//  AppDelegate.swift
//  KabarKabari
//
//  Created by Emerio-Mac2 on 19/05/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import UIKit

import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate, MessagingDelegate{
    
     var window: UIWindow?
     let gcmMessageIDKey = "gcm.message_id"
     var notification : Bool = false
     var id : Int = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupPushNotificationsHandling(application)
        return true
    }
    
    private func setupPushNotificationsHandling(_ application: UIApplication) {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        application.registerForRemoteNotifications()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Receive notifications from the "all" topic
        subscribeToNotificationsTopic(topic: "allnews")
    }
    
    func subscribeToNotificationsTopic(topic: String) {
        // Retry until the notifications subscription is successful
        DispatchQueue.global().async {
            var subscribed = false
            while !subscribed {
                let semaphore = DispatchSemaphore(value: 0)
                
                InstanceID.instanceID().instanceID { (result, error) in
                    if let result = result {
                        // Device token can be used to send notifications exclusively to this device
                        print("Device token \(result.token)")
                        
                        // Subscribe
                        Messaging.messaging().subscribe(toTopic: topic)
                        
                        // Notify semaphore
                        subscribed = true
                        semaphore.signal()
                    }
                }
                
                // Set a 3 seconds timeout
                let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(3)
                _ = semaphore.wait(timeout: dispatchTime)
            }
        }
    }
    
        func setRootViewController(_ viewController: UIViewController) {
    
            UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: { () -> Void in
    
                let oldState = UIView.areAnimationsEnabled
    
                UIView.setAnimationsEnabled(false)
                self.window?.rootViewController = viewController
                UIView.setAnimationsEnabled(oldState)
    
            }, completion: nil)
        }
    
        func showMainViewController() {
    
            let storyboard = UIStoryboard(name: "TabbarMenu", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabbarMenu")
    
            setRootViewController(vc)
        }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("userinfolo\(userInfo)")
        print(userInfo["id"] as Any)
        self.notification = true
        let idString = userInfo["newsId"] as? String
        self.id = Int(idString ?? "0") ?? 0
        showMainViewController()
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        completionHandler([.alert, .sound])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}


