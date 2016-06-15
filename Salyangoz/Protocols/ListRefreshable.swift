//
//  ListRefreshable.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 15/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import Foundation

protocol ListRefreshable{
    weak var tableView: UITableView! {get set}
    
    func initializeRefresher()
    func getData()
}

extension ListRefreshable where Self: UIViewController{
    func initializeRefresher(){
        let refresher = PullToRefresh()
        self.tableView.addPullToRefresh(refresher) {
            self.getData()
        }
    }
}
