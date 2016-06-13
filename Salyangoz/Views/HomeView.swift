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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        setBarAppearances()
        getHomeItems()
        registerSectionHeaderNib()
    }
    
    //MARK: Private Helper Methods
    func getHomeItems(){
        SalyangozAPI.sharedAPI.getHomeFeed { (feed, error) in
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
}

extension HomeView: UITableViewDataSource, UITableViewDelegate{
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
        if let feed = self.feed{
            if let sectionItem: User = feed[indexPath.section]{
                if let posts = sectionItem.posts{
                    let cellPost: Post = posts[indexPath.row]
                    cell.configureCell(cellPost)
                }
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(HomeSectionHeader)) as! HomeSectionHeader
        cell.contentView.backgroundColor = UIColor.blueColor()
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
        
        let archive = UITableViewRowAction(style: .Normal, title: "Read") { action, index in
            print("more button tapped")
        }
        archive.backgroundColor = UIColor.greenColor()
        return [archive]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
}