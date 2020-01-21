//
//  AppDelegate.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 1/31/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //push notifications
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
        var navigationController = UINavigationController()
        
        if UserDefaults.standard.bool(forKey: Constants.Defines.alreadyLogin) == true {
            let mainStatViewController = CTStatisticViewController(nibName:"CTStatisticViewController", bundle: nil)
            navigationController = UINavigationController(rootViewController: mainStatViewController)
            
            let loginModel = LoginModel()
            loginModel.sessionId = UserDefaults.standard.value(forKey: Constants.Defines.sessionId) as? String
            ModelsManager.shared.loginModel = loginModel
        } else {
            let loginViewController = CTLoginViewController(nibName: "CTLoginViewController", bundle: nil)
            navigationController = UINavigationController(rootViewController: loginViewController)
        }
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isTranslucent = false
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        return true
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


    //MARK: - Push Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceTokenString, forKey: Constants.Defines.deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
