//
//  AppDelegate.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 08/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import SalyangozKit

import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var credentials = NSBundle.contentsOfFile("Credentials.plist")
        if let consumerKey = credentials["consumerKey"] as? String, consumerSecret = credentials["consumerSecret"] as? String{
            Twitter.sharedInstance().startWithConsumerKey(consumerKey, consumerSecret: consumerSecret)
            Fabric.with([Twitter.self()])
        }
        
        if !DataManager.sharedManager.isLoggedIn(){
            Wireframe.sharedWireframe.showLoginViewAsRootView()
        }
        
        return true
    }

}
