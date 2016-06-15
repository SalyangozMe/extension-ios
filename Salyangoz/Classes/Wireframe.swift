
//  Wireframe.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
import SalyangozKit
import SafariServices

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
                DataManager.sharedManager.setTutorialSeen(true)
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
                mainTabBarController.viewControllers?.insert(homeNavigationController, atIndex: 0)
                self.keyWindow?.rootViewController = mainTabBarController
            }
        }
    }
    
    func showTutorialAsRootView(){
        if let tutorialContainerView: TutorialContainerView = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(String(TutorialContainerView)) as? TutorialContainerView{
            self.keyWindow?.rootViewController = tutorialContainerView
        }
    }
    
    func showTabBarAsRootView(){
        let navigationController: UINavigationController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(homeNavigationControllerIdentifier) as! UINavigationController
        self.keyWindow?.rootViewController = navigationController
    }
    
    func openURLInViewController(url: NSURL, viewController: UIViewController){
        let safariVC = SFSafariViewController(URL: url)
        viewController.presentViewController(safariVC, animated: true, completion: nil)
    }
    
    func logout(){
        if let session = Twitter.sharedInstance().sessionStore.session(){
            Twitter.sharedInstance().sessionStore.logOutUserID(session.userID)
        }
        DataManager.sharedManager.removeSession()
        self.showLoginViewAsRootView()
    }
}