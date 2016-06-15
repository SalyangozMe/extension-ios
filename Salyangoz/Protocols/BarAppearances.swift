//
//  AppearanceProtocol.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit

protocol BarAppearances {
    func setBarAppearances()
}

extension BarAppearances where Self: UIViewController{
    
    func setBarAppearances(){
        let titleTextAttributes = [ NSFontAttributeName: UIFont.applicationNavigationHeadingFont(),
                                    NSForegroundColorAttributeName: UIColor.applicationNavigationTitleColor()]
        
        if let navigationController = self.navigationController{
            navigationController.navigationBar.titleTextAttributes = titleTextAttributes
        }
        
        if let tabBarController = self.tabBarController{
            tabBarController.tabBar.layer.borderWidth = 0.5
            tabBarController.tabBar.layer.borderColor = UIColor.applicationTabBarBorderTopColor().CGColor
            tabBarController.tabBar.clipsToBounds = true
        }
    }
}