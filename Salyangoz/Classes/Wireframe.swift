//
//  Wireframe.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation
import UIKit
import SalyangozKit

class Wireframe{
    static let sharedWireframe = Wireframe()
    let homeNavigationControllerIdentifier = "HomeNavigationController"
    let mainTabBarControllerIdentifier = "MainTabBarController"
    
    var keyWindow: UIWindow?{
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window{
            return window
        }else{
            return nil
        }
    }
    
    var loginView: LoginView?{
        if let loginView = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(String(LoginView)) as? LoginView{
            return loginView
        }
        return nil
    }
    
    init(){
        
    }
    
    func showProperView(){
        if !DataManager.sharedManager.isLoggedIn(){
            if DataManager.sharedManager.isTutorialSeen() {
                self.showLoginViewAsRootView()
            }else{
                DataManager.sharedManager.setTutorialSeenStatus(true)
                self.showTutorialAsRootView()
            }
        }else{
            showTabBarWithLogin()
        }
    }
    
    func showLoginViewAsRootView(){
        self.keyWindow?.rootViewController = loginView
    }
    
    func showTabBarWithoutLogin(){
        if let mainTabBarController: UITabBarController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(mainTabBarControllerIdentifier) as? UITabBarController{
            self.keyWindow?.rootViewController = mainTabBarController
        }
    }
    
    func showTabBarWithLogin(){
        if let mainTabBarController: UITabBarController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(mainTabBarControllerIdentifier) as? UITabBarController{
            if let homeNavigationController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(homeNavigationControllerIdentifier) as? UINavigationController{
                
                print(mainTabBarController.viewControllers)
                mainTabBarController.viewControllers?.insert(homeNavigationController, atIndex: 0)
                self.keyWindow?.rootViewController = mainTabBarController
            }
        }
    }
    
    func showTutorialAsRootView(){
        
    }
    
    func showTabBarAsRootView(){
        let navigationController: UINavigationController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(homeNavigationControllerIdentifier) as! UINavigationController
        self.keyWindow?.rootViewController = navigationController
    }
}