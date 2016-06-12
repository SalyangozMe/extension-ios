//
//  RecentCell.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit
import TimeAgoInWords
import AlamofireImage

class RecentCell: UITableViewCell{
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var cellDetailLabel: UILabel!
    @IBOutlet private weak var cellTitleLabel: UILabel!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        userImageView.layer.cornerRadius = 18
        userImageView.layer.masksToBounds = true
    }
 
    func configureCell(cellItem: Post){
        cellTitleLabel.text = cellItem.title
        if let itemURL = cellItem.url, timeAgo = cellItem.updatedAt?.timeAgoInWords(){
            if let host = itemURL.host{
                let cellDetailLabelText = "\(host) · \(timeAgo) ago"
                cellDetailLabel.text = cellDetailLabelText
            }
        }
        if let user: FeedUser = cellItem.feedUser{
            if let profileImageURL = user.getProfileImageURL(){
                userImageView.af_setImageWithURL(profileImageURL)
            }
        }
    }
}