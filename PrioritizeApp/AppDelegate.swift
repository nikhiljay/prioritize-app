//
//  AppDelegate.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/7/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let applicationShortcutUserInfoIconKey = "applicationShortcutUserInfoIconKey"
    
    enum ShortcutType: String {
        case AddNew = "reverse.domain.addnew"
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.setApplicationId("I6d6qWhllid82u0RbaoMHLZgrDOXRKKif2WLPzCe", clientKey: "hl6qFfbajRQq3Twq8MO7DeQsJ4iuGv9mnyvx1ZAN")
        self.window?.makeKeyAndVisible()
        if (PFUser.currentUser() == nil) {
            presentLoginViewController()
        }
        
        var launchedFromShortCut = false
        //Check for ShortCutItem
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
                launchedFromShortCut = true
                handleShortCutItem(shortcutItem)
            }
        } else {}
        
        return !launchedFromShortCut
    }
    
    func presentLoginViewController() {
        if PFUser.currentUser() == nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("loginNav") as! UINavigationController
            
            self.window?.rootViewController?.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    //MARK: Short Cut Item Methods
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: Bool -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        completionHandler(handledShortCutItem)
    }
    
    @available(iOS 9.0, *)
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        //Get type string from shortcutItem
        if let shortcutType = ShortcutType.init(rawValue: shortcutItem.type) {
            //Get root navigation viewcontroller and its first controller
            let rootNavigationViewController = window!.rootViewController as? UINavigationController
            let rootViewController = rootNavigationViewController?.viewControllers.first as UIViewController?
            //Pop to root view controller so that approperiete segue can be performed
            rootNavigationViewController?.popToRootViewControllerAnimated(false)
            
            switch shortcutType {
            case .AddNew:
                rootViewController?.performSegueWithIdentifier(addItemSegue, sender: nil)
                handled = true
            }
        }
        
        return handled
    }

    //MARK: Other Methods
    func applicationWillResignActive(application: UIApplication) {
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

