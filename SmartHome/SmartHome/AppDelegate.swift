//
//  AppDelegate.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/2.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UMessage.start(withAppkey: "5a5694eef43e487ec400096c", launchOptions: nil, httpsEnable: true)
        UMessage.registerForRemoteNotifications()
        
        let options: UNAuthorizationOptions = UNAuthorizationOptions.init(rawValue: UNAuthorizationOptions.alert.rawValue|UNAuthorizationOptions.badge.rawValue|UNAuthorizationOptions.sound.rawValue)
        UNUserNotificationCenter.current().requestAuthorization(options:options) { (success, error) in
            if success{
                print("ok")
            }else{
                
            }
        }
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        UMessage.setLogEnabled(true)

        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let home = UIStoryboard.init(name: "HomeViewController", bundle: nil).instantiateInitialViewController()
        let navi = MainNavigationController(rootViewController: home!)
        navi.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceId = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(deviceId)
        UMessage.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UMessage.didReceiveRemoteNotification(userInfo)
        completionHandler(.newData)
    }


}

