//
//  UIFontExtensions.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation

public enum SalyangozFont: String{
    case SalyangozFontRegular = "Roboto-Regular"
    case SalyangozFontItalic = "Roboto-Italic"
    
    case SalyangozFontLight = "Roboto-Light"
    case SalyangozFontLightItalic = "Roboto-LightItalic"
    
    case SalyangozFontMedium = "Roboto-Medium"
    case SalyangozFontMediumItalic = "Roboto-MediumItalic"
    
    case SalyangozFontCondensedRegular = "RobotoCondensed-Regular"
    case SalyangozFontCondensedItalic = "RobotoCondensed-Italic"
}

public extension UIFont{
    public static func applicationFont(fontType: SalyangozFont, size: CGFloat) -> UIFont{
        if let font = UIFont(name: fontType.rawValue, size: size){
            return font
        }else{
            return UIFont.systemFontOfSize(size)
        }
    }
    
    public static func applicationNavigationHeadingFont() -> UIFont{
        return UIFont.applicationFont(SalyangozFont.SalyangozFontMedium, size: 18)
    }
    
    public static func applicationTabBarItemTitleFont() -> UIFont{
        return UIFont.applicationFont(SalyangozFont.SalyangozFontLight, size: 11)
    }
}