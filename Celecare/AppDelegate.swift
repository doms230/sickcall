//
//  AppDelegate.swift
//  Celecare
//
//  Created by Dominic Smith on 10/31/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import UserNotifications
import Parse
import FacebookCore
import FacebookLogin
import ParseFacebookUtilsV4
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    var color = Color()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color.sickcallGreen()], for:UIControlState())
        
        UITabBar.appearance().tintColor = color.sickcallGreen()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.barTintColor = UIColor.white
        navigationBarAppearace.tintColor = color.sickcallGreen()
        
        //Initialize Stripe
        STPPaymentConfiguration.shared().publishableKey = "pk_test_oP3znUobvO9fTRuYb6Qo7PYB"
        
        //Initialize Parse
        
        Parse.enableLocalDatastore()
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "O9M9IE9aXxHHaKmA21FpQ1SR26EdP2rf4obYxzBF"
            $0.clientKey = "LdoCUneRAIK9sJLFFhBFwz2YkW02wChG5yi2wkk2"
            $0.server = "https://celecare.herokuapp.com/parse"
        }
        Parse.initialize(with: configuration)
        
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        
        if (PFUser.current() != nil){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
            self.window?.rootViewController = initialViewController
            
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "welcome")
            self.window?.rootViewController = initialViewController
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let installation = PFInstallation.current()
        installation?.badge = 0
        installation?.saveInBackground()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.badge = 0
        installation?.saveInBackground()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if ( application.applicationState == UIApplicationState.background ){
            PFPush.handle(userInfo)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        PFPush.handle(notification.request.content.userInfo)
        completionHandler(.alert)
    }
    
    func checkUserDefaults(){
        if let side = UserDefaults.standard.string(forKey: "side"){
            if side == "patient"{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
            } else {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "container")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
            
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    }
}
