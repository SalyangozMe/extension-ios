//
//  UIFontExtensions.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
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
}

public extension UIFont{
    public static func applicationFont(fontType: SalyangozFont, size: CGFloat) -> UIFont{
        if let font = UIFont(name: fontType.rawValue, size: size){
            return font
        }else{
            return UIFont.systemFontOfSize(size)
        }
    }
}