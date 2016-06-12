//
//  HomeView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import Foundation

class HomeView: UIViewController, BarAppearances{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        setBarAppearances()
    }
}