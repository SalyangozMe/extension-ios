//
//  HomeView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import TwitterKit
import SalyangozKit

class HomeView: UIViewController{
 
    override func viewDidLoad() {
        self.setupUI()
    }
    
    // MARK: Private Helper Methods
    func setupUI(){
        self.title = "Salyangoz"
        
        let logoutButton = UIBarButtonItem(image: UIImage(named: "Logout"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(confirmLogout))
        logoutButton.tintColor = UIColor.darkGrayColor()
        let titleTextAttributes = [ NSFontAttributeName: UIFont.applicationFont(SalyangozFont.SalyangozFontMedium, size: 18)]
     
        if let navigationController = self.navigationController{
            self.navigationItem.setRightBarButtonItem(logoutButton, animated: false)
            navigationController.navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    
    func confirmLogout(){
        let alertController = UIAlertController(title: "Logging Out", message: "Are you sure you want to log out?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "Okay", style: .Default) { (action) in
            self.logout()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func logout(){
        if let session = Twitter.sharedInstance().sessionStore.session(){
            Twitter.sharedInstance().sessionStore.logOutUserID(session.userID)
        }
        DataManager.sharedManager.removeLoginResponse()
        Wireframe.sharedWireframe.showLoginViewAsRootView()
    }
}