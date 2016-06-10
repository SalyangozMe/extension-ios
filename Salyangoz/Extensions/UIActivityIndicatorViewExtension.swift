//
//  UIActivityIndicatorExtension.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import Foundation

public extension UIActivityIndicatorView{
    
    public func show(){
        self.startAnimating()
        self.hidden = false
    }
    
    public func hide(){
        self.stopAnimating()
        self.hidden = true
    }
}