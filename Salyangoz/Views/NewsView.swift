//
//  NewsView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit

class NewsView: UIViewController, BarAppearances, ListRefreshable{
    
    var feed: [User]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New"
        setBarAppearances()
        registerSectionHeaderNib()
        initializeRefresher()
        self.getData()
        showProperBarButton(nil, logoutSelector: #selector(NewsView.logout))
    }
    
    //MARK: Private Helper Methods
    func getData(){
        self.tableView.startRefreshing()
        SalyangozAPI.sharedAPI.getNewsFeed { (feed, error) in
            self.tableView.endRefreshing()
            if let feed = feed{
                self.feed = feed
                self.tableView.reloadData()
            }else if let error = error{
                let firstAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                self.alert("An error occured", message: error.localizedDescription, action: firstAction)
                print(error.localizedDescription)
            }
        }
    }
    
    func registerSectionHeaderNib(){
        let nib = UINib(nibName: String(NewsSectionHeader), bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: String(NewsSectionHeader))
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
    
    func removePost(at indexPath: NSIndexPath){
        self.feed?[indexPath.section].posts?.removeAtIndex(indexPath.row)
        if self.feed?[indexPath.section].posts?.count == 0{
            self.feed?.removeAtIndex(indexPath.section)
        }
    }
    
    func deleteRow(at indexPath: NSIndexPath){
        self.tableView.beginUpdates()
        
    
        if self.feed?[indexPath.section].posts?.count == 1{
            self.tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
        }else{
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        self.removePost(at: indexPath)
        self.tableView.endUpdates()
        
        //let sections = NSIndexSet(index: indexPath.section)
        //self.tableView.reloadSections(sections, withRowAnimation: .Fade)
    }
}

extension NewsView: UITableViewDataSource{
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
        let cell = tableView.dequeueReusableCellWithIdentifier(String(NewsCell), forIndexPath: indexPath) as! NewsCell
        if let cellPost: Post = self.getCellItem(indexPath){
            cell.configureCell(cellPost)
        }
        return cell
    }
}

extension NewsView: UITableViewDelegate{
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard self.feed?[section].posts?.count > 0 else { return nil }
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(NewsSectionHeader)) as! NewsSectionHeader
        
        if let feed = self.feed{
            if let sectionItem: User = feed[section]{
                cell.configureCell(sectionItem)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard self.feed?[section].posts?.count == 0 else { return nil }
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let archive = UITableViewRowAction(style: .Normal, title: NSLocalizedString("Archive", comment: "")) { action, index in
            if let cellPost = self.getCellItem(index){
                self.deleteRow(at: indexPath)
                SalyangozAPI.sharedAPI.archivePost(cellPost, completion: nil)
            }
        }
        archive.backgroundColor = UIColor(red: 0.0, green: 0.65, blue:0.35, alpha: 1)
        return [archive]
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
                self.deleteRow(at: indexPath)
                SalyangozAPI.sharedAPI.markPostAsVisited(cellPost, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}