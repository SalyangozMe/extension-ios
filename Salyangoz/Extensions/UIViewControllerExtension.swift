//
//  UIViewController.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit

extension UIViewController {
    
    func alert(title: String = "", message: String, action: UIAlertAction){
        _alert(title, message: message, firstAction: action, secondAction: nil)
    }
    
    func alert(title: String = "", message: String, firstAction: UIAlertAction, secondAction: UIAlertAction){
        _alert(title, message: message, firstAction: firstAction, secondAction: secondAction)
    }
    
    func showProperBarButton(loginSelector: Selector?, logoutSelector: Selector?){
        if DataManager.sharedManager.isLoggedIn(){
            if let logoutSelector = logoutSelector{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Logout"), style: .Plain, target: self, action: logoutSelector)
            }
        }else{
            if let loginSelector = loginSelector{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .Plain, target: self, action: loginSelector)
            }
        }
    }
    
    func logout(){
        let firstAction = UIAlertAction(title: "Okay", style: .Default) { (UIAlertAction) in
            Wireframe.sharedWireframe.logout()
        }
        let secondAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        _ = self.alert("Logging out", message: "Are you sure you want to log out?", firstAction: firstAction, secondAction: secondAction)
    }
    
    private func _alert(title: String = "", message: String, firstAction: UIAlertAction, secondAction: UIAlertAction?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(firstAction)
        if let secondAction = secondAction{
            alertController.addAction(secondAction)
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}