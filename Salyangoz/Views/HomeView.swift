//
//  HomeView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit

class HomeView: UIViewController, BarAppearances{
    
    var feed: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        setBarAppearances()
        getHomeItems()
    }
    
    //MARK: Private Helper Methods
    func getHomeItems(){
        SalyangozAPI.sharedAPI.getHomeFeed { (feed, error) in
            if let feed = feed{
                print(feed)
            }else{
                print(error?.localizedDescription)
            }
        }
    }
}