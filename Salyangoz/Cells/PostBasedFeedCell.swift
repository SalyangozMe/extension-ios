//
//  PostBasedFeedCell.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit
import TimeAgoInWords
import AlamofireImage

class PostBasedFeedCell: UITableViewCell{
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var cellDetailLabel: UILabel!
    @IBOutlet private weak var cellTitleLabel: UILabel!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        userImageView.layer.cornerRadius = 18
        userImageView.layer.masksToBounds = true
    }
 
    func configureCell(post: Post){
        cellTitleLabel.text = post.title
        
        if let postDetailsDescription = post.postDetailsDescription{
            cellDetailLabel.text = postDetailsDescription
            
            if let count = post.visitCount, desc = post.viewsCountDescription{
                if count != 0{
                    cellDetailLabel.text = postDetailsDescription + " · \(count) \(desc)"
                }
            }
        }
        
        if let user: User = post.owner{
            if let profileImageURL = user.profileImageURL{
                userImageView.af_setImageWithURL(profileImageURL)
            }
        }
    }
}