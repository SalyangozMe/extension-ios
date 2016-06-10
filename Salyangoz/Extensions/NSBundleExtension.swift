//
//  NSBundleExtension.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 08/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation

public extension NSBundle {
    
    public static func contentsOfFile(plistName: String, bundle: NSBundle? = nil) -> [String: AnyObject]{
        let fileParts = plistName.componentsSeparatedByString(".")
        
        guard fileParts.count == 2,
            let resourcePath = (bundle ?? NSBundle.mainBundle()).pathForResource(fileParts[0], ofType: fileParts[1]),
            let contents = NSDictionary(contentsOfFile: resourcePath) as? [String: AnyObject]
            else{return [:]}
        return contents
    }
}