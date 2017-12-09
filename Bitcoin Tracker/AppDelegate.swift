	//
//  AppDelegate.swift
//  Bitcoin Tracker
//
//  Created by Matthew Batsinelas on 11/28/17.
//  Copyright © 2017 Matthew Batsinelas. All rights reserved.
//

import UIKit
import UserNotifications
    
    
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
        
    var window: UIWindow?
        
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            
if #available(iOS 10.0, *) {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
    }} else {
    print("error")
            }
    return true
}
    
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler( [.alert, .badge, .sound])
        }

func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            completionHandler()
        }
        
func applicationWillResignActive(_ application: UIApplication) {
        }
        
func applicationDidEnterBackground(_ application: UIApplication) {
        }
        
func applicationWillEnterForeground(_ application: UIApplication) {
        }
        
func applicationDidBecomeActive(_ application: UIApplication) {
        }
        
func applicationWillTerminate(_ application: UIApplication) {
        }
    }
