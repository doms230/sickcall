//
//  AppDelegate.swift
//  Sickcall
//
//  Created by Dominic Smtih on 7/19/17.
//  Copyright © 2017 Sickcall All rights reserved.
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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //change color of time/status jaunts to white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for:UIControlState())
        
        UITabBar.appearance().tintColor = uicolorFromHex(0x159373)
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.barTintColor = uicolorFromHex(0xffffff)
        navigationBarAppearace.tintColor = uicolorFromHex(0x159373)
        
        //Stripe ***
        //STPPaymentConfiguration.shared().publishableKey = "pk_test_oP3znUobvO9fTRuYb6Qo7PYB"
        STPPaymentConfiguration.shared().publishableKey = "pk_live_chGMzaqKctIYqbalvJbvRzWz"
        
        //Parse *****
        
        // Override point for customization after application launch.
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        
        //MARK - this is the real one below
        let configuration = ParseClientConfiguration {
            $0.applicationId = "O9M9IE9aXxHHaKmA21FpQ1SR26EdP2rf4obYxzBF"
            $0.clientKey = "LdoCUneRAIK9sJLFFhBFwz2YkW02wChG5yi2wkk2"
            $0.server = "https://celecare.herokuapp.com/parse"
           // $0.server = "http://192.168.1.75:5000/parse"
        }
        Parse.initialize(with: configuration)
        
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)

        
        //PFUser.logOut()
        
        if (PFUser.current() != nil){
            let query = PFQuery(className: "Advisor")
            query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
            query.getFirstObjectInBackground {
                (object: PFObject?, error: Error?) -> Void in
                if error == nil || object != nil {
                    if object?["isOnline"] as! Bool{
                        let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "container") as! AdvisorContainerViewController
                        initialViewController.isAdvisor = true
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                        
                    } else {
                        self.checkUserDefaults()
                    }
                    
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
                }
            }
            
        } else {
            //usealy "welcome" for storyboard id.. replaced with meds for testing
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "welcome")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
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
        let installation = PFInstallation.current()
        //replace badge # when someone clicks on notification
        installation?.badge = 0
        installation?.saveInBackground()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("deviceToken \(deviceToken)")
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        //replace badge # when someone clicks on notification
        installation?.badge = 0
        installation?.saveInBackground()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //parse stuff
        if ( application.applicationState == UIApplicationState.background ){
            PFPush.handle(userInfo)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        PFPush.handle(notification.request.content.userInfo)
        completionHandler(.alert)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    //define custom color jaunts..  see https://coderwall.com/p/dyqrfa/customize-navigation-bar-appearance-with-swift for reference
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
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


