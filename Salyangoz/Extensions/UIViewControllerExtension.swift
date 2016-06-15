//
//  UIViewController.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    
    func alert(title: String = "", message: String, action: UIAlertAction){
        _alert(title, message: message, firstAction: action, secondAction: nil)
    }
    
    func alert(title: String = "", message: String, firstAction: UIAlertAction, secondAction: UIAlertAction){
        _alert(title, message: message, firstAction: firstAction, secondAction: secondAction)
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