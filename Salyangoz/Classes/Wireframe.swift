//
//  Wireframe.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation
import UIKit

class Wireframe{
    static let sharedWireframe = Wireframe()
    let homeNavigationControllerIdentifier = "HomeNavigationController"
    
    var keyWindow: UIWindow?{
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window{
            return window
        }else{
            return nil
        }
    }
    
    init(){
        
    }
    
    func showLoginViewAsRootView(){
        let loginView = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(String(LoginView))
        self.keyWindow?.rootViewController = loginView
    }
    
    func showTabBarAsRootView(){
        let navigationController: UINavigationController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(homeNavigationControllerIdentifier) as! UINavigationController
        self.keyWindow?.rootViewController = navigationController
    }
}