//
//  AppDelegate.swift
//  SMFInventory
//
//  Created by Emerio-Mac2 on 15/09/18.
//  Copyright © 2018 Emerio-Mac2. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-2551441341997407~4062270142")
        return true
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

}

