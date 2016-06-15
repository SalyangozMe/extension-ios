//
//  TabView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation
import TwitterKit
import SalyangozKit
import SafariServices

class RecentView: UIViewController, BarAppearances, ListRefreshable{
    var loginSelector: Selector?{
        get{
            return #selector(RecentView.login)
        }
    }
    
    var logoutSelector: Selector?{
        get{
            return #selector(RecentView.logout)
        }
    }
    
    var feed: [Post]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recent"
        setBarAppearances()
        getData(nil)
        initializeRefresher()
        showProperBarButton(#selector(RecentView.login), logoutSelector: #selector(RecentView.logout))
    }
    
    func getData(completion: (() -> Void)?) {
        SalyangozAPI.sharedAPI.getRecentFeed { (feed, error) in
            if let completion = completion{
                completion()
            }
            if feed != nil{
                self.feed = feed
                self.tableView.reloadData()
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
    func login(){
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
        if let feed = self.feed{
            let selectedPost = feed[indexPath.row]
            if let postURL = selectedPost.url{
                Wireframe.sharedWireframe.openURLInViewController(postURL, viewController: self)
            }
        }
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
    }
}
