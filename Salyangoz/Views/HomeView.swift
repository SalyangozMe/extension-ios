//
//  HomeView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit

class HomeView: UIViewController, BarAppearances, ListRefreshable{
    
    var feed: [User]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        setBarAppearances()
        registerSectionHeaderNib()
        initializeRefresher()
        self.getData()
        showProperBarButton(nil, logoutSelector: #selector(HomeView.logout))
    }
    
    //MARK: Private Helper Methods
    func getData(){
        self.tableView.startRefreshing()
        SalyangozAPI.sharedAPI.getHomeFeed { (feed, error) in
            self.tableView.endRefreshing()
            if let feed = feed{
                self.feed = feed
                self.tableView.reloadData()
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
    func registerSectionHeaderNib(){
        let nib = UINib(nibName: String(HomeSectionHeader), bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: String(HomeSectionHeader))
    }
    
    func getCellItem(indexPath: NSIndexPath) -> Post?{
        if let feed = self.feed{
            if let sectionItem: User = feed[indexPath.section]{
                if let posts = sectionItem.posts{
                    let cellPost: Post = posts[indexPath.row]
                    return cellPost
                }
            }
        }
        return nil
    }
    
    func removePostAtIndex(indexPath: NSIndexPath){
        self.feed?[indexPath.section].posts?.removeAtIndex(indexPath.row)
    }
    
    func markPostAsVisited(at index: NSIndexPath, completion:booleanCompletionHandlerType?){
        if let cellPost = self.getCellItem(index){
            SalyangozAPI.sharedAPI.markPostAsVisited(cellPost, completion: completion)
        }
    }
}

extension HomeView: UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let feed = self.feed{
            return feed.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = self.feed{
            if let sectionItem: User = feed[section]{
                if let posts = sectionItem.posts{
                    return posts.count
                }
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(HomeCell), forIndexPath: indexPath) as! HomeCell
        if let cellPost: Post = self.getCellItem(indexPath){
            cell.configureCell(cellPost)
        }
        return cell
    }
}

extension HomeView: UITableViewDelegate{
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(HomeSectionHeader)) as! HomeSectionHeader
        
        if let feed = self.feed{
            if let sectionItem: User = feed[section]{
                cell.configureCell(sectionItem)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let archive = UITableViewRowAction(style: .Normal, title: NSLocalizedString("Visited", comment: "")) { action, index in
            self.markPostAsVisited(at: indexPath, completion: { (success) in
                
            })
        }
        archive.backgroundColor = UIColor(red: 0.0, green: 0.65, blue:0.35, alpha: 1)
        return nil
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cellPost: Post = self.getCellItem(indexPath){
            if let url = cellPost.url{
                Wireframe.sharedWireframe.openURLInViewController(url, viewController: self)
                self.markPostAsVisited(at: indexPath, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}