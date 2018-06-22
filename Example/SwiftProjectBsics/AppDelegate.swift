//
//  AppDelegate.swift
//  SwiftProjectBsics
//
//  Created by ssTaoz on 05/27/2018.
//  Copyright (c) 2018 ssTaoz. All rights reserved.
//

import UIKit
import SwiftProjectBsics
import CryptoSwift

@UIApplicationMain
class AppDelegate: BaseAppDelegate {

    //var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AppConfig.shared.startNetworkListening()

        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AppConfig.shared.networkReachabilityManager?.stopListening()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
         AppConfig.shared.startNetworkListening()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

