//
//  TabView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import Foundation
import TwitterKit
import SalyangozKit

class RecentView: UIViewController, BarAppearances{
    
    var feed: [Post]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recent"
        setBarAppearances()
        getRecentItems()
    }
    
    func getRecentItems(){
        SalyangozAPI.sharedAPI.getRecentFeed { (feed, error) in
            if feed != nil{
                self.feed = feed
                self.tableView.reloadData()
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
    func logout(){
        if let session = Twitter.sharedInstance().sessionStore.session(){
            Twitter.sharedInstance().sessionStore.logOutUserID(session.userID)
        }
        DataManager.sharedManager.removeSession()
        Wireframe.sharedWireframe.showLoginViewAsRootView()
    }
}

extension RecentView: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(RecentCell), forIndexPath: indexPath) as! RecentCell
        if let feed = self.feed{
            let cellItem: Post = feed[indexPath.row]
            cell.configureCell(cellItem)
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = self.feed{
            return feed.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
    }
}
