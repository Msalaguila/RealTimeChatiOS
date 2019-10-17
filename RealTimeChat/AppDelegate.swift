//
//  AppDelegate.swift
//  Firebase
//
//  Created by Manuel Salvador del Águila on 14/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
//import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var MAPS_API_KEY = "AIzaSyAhapV6lfl4n9P0PqGO2HTW9NxedZfc3K8"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        
        application.beginBackgroundTask(withName: "notification", expirationHandler: nil)
        
        GMSServices.provideAPIKey(MAPS_API_KEY)
        
        FirebaseApp.configure()
//        IQKeyboardManager.shared().isEnabled = true
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let navController = UINavigationController(rootViewController: HomeViewController())
        window?.rootViewController = navController
        
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
}

