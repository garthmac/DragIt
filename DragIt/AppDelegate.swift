//
//  AppDelegate.swift
//  DragIt
//
//  Created by iMac 27 on 2015-10-15.
//  Copyright © 2015 iMac 27. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
        //        if firstLaunch  {
        //            println("Not first launch.")
        //        }
        //        else {
        //            println("First launch, setting NSUserDefault.")
        //            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
        //        }
        return true
    }
    
    struct Motion {
        static let Manager = CMMotionManager()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        //  explicitly opt out of background by adding the UIApplicationExitsOnSuspend key (with the value YES) to your app’s Info.plist file. When an app opts out, it cycles between the not-running, inactive, and active states and never enters the background or suspended states. When the user presses the Home button to quit the app, the applicationWillTerminate: method of the app delegate is called and the app has approximately 5 seconds to clean up and exit

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

