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

class PostBasedFeedView: UIViewController, BarAppearances, PostBasedFeedDataSourceProtocol{
    
    var feed: [Post]?
    var beforeCompletionHandler: () -> Void {
        get {
            return {
                self.tableView.startRefreshing()
            }
        }
    }
    
    var afterCompletionHandler: postBasedFeedCompletionHandlerType {
        get {
            return { (feed, error) in
                self.tableView.endRefreshing()
                if feed != nil{
                    self.feed = feed
                    self.tableView.reloadData()
                }else if let error = error{
                    let firstAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                    self.alert("An error occured", message: error.localizedDescription, action: firstAction)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    var feedType: PostBasedFeedType {
        get {
            if let tabBarController = self.tabBarController{
                if let viewControllersCount = self.tabBarController?.viewControllers?.count{
                    let selectedIndex = tabBarController.selectedIndex
                    
                    if viewControllersCount - 1 == selectedIndex{
                        return .Popular
                    }else if viewControllersCount - 2 == selectedIndex{
                        return .Recent
                    }
                    
                }
            }
            return .Recent
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var loginSelector: Selector?{
        get{
            return #selector(PostBasedFeedView.login)
        }
    }
    
    var logoutSelector: Selector?{
        get{
            return #selector(PostBasedFeedView.logout)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setBarAppearances()
        showProperBarButton(#selector(PostBasedFeedView.login), logoutSelector: #selector(PostBasedFeedView.logout))
        
        self.title = self.feedType.rawValue
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initializeRefresher()
        if nil == self.feed{
            self.getData()
        }
    }
    
    func initializeRefresher(){
        let refresher = PullToRefresh()
        self.tableView.addPullToRefresh(refresher) {
            self.getData()
        }
    }
    
    func registerNib(){
        let nibName = UINib(nibName: String(PostBasedFeedCell), bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: String(PostBasedFeedCell))
    }
}

extension PostBasedFeedView: UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(PostBasedFeedCell), forIndexPath: indexPath) as! PostBasedFeedCell
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
}

extension PostBasedFeedView: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let feed = self.feed{
            let selectedPost = feed[indexPath.row]
            if let postURL = selectedPost.url{
                Wireframe.sharedWireframe.openURLInViewController(postURL, viewController: self)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}