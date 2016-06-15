//
//  UIStoryboardExtension.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation

let mainStoryboardName = "Main"

public extension UIStoryboard{
    
    public static func mainStoryboard() -> UIStoryboard{
        return UIStoryboard(name: mainStoryboardName, bundle: NSBundle.mainBundle())
    }
}
