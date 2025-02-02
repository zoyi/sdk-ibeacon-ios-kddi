//
//  AppDelegate.swift
//  ZBeaconKitExample
//
//  Created by R3alFr3e on 2/21/18.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit
import ZBeaconKitKDDI
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var inputPipe: Pipe!
  var outputPipe: Pipe!

  let manager = Manager(email: "example@zoyi.co", authToken: "YOUR_AUTH_TOKEN", target: .Development)

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    Manager.debugMode = true
    Manager.customerId = self.generateSampleCustomerId()

    if launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
      self.manager.restart()
    }

    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    center.requestAuthorization(options: options) {
      (granted, error) in
      if !granted {
        print("Something went wrong")
      }
    }

    return true
  }

  func generateSampleCustomerId() -> String {
    let deviceId = UIDevice.current.identifierForVendor?.uuidString
    let deviceIdWithSalt = deviceId! + "YOUR_SALT"
    return deviceIdWithSalt.hmac(.sha512, key: "YOUR_KEY_FOR_HMAC")
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

}

