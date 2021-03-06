//
//  NewsSectionHeader.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 13/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit

class NewsSectionHeader: UITableViewHeaderFooterView{
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        profileImageView.layer.cornerRadius = CGRectGetWidth(profileImageView.frame)/2
        profileImageView.layer.masksToBounds = true
    }
    
    func configureCell(user: User){
        usernameLabel.text = user.username
        if let profileImageURL = user.profileImageURL{
            profileImageView.af_setImageWithURL(profileImageURL)
        }
    }
}