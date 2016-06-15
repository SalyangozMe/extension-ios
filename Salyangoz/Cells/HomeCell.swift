//
//  HomeCell.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 12/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit

class HomeCell: UITableViewCell{
    @IBOutlet weak var viewCount: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellDetailLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        viewCount.layer.cornerRadius = CGRectGetWidth(viewCount.frame)/2
        viewCount.layer.masksToBounds = true
    }
    
    func configureCell(post: Post){
        titleLabel.text = post.title
        if let itemURL = post.url, timeAgo = post.updatedAt?.timeAgoInWords(){
            if let host = itemURL.host{
                let cellDetailLabelText = "\(host) · \(timeAgo) ago"
                cellDetailLabel.text = cellDetailLabelText
            }
        }
        
        if let count = post.visitCount{
            viewCount.setTitle("\(count)", forState: .Normal)
            if count > 1{
                viewsLabel.text = NSLocalizedString("views", comment: "")
            }else if (count == 1){
                viewsLabel.text = NSLocalizedString("view", comment: "")
            }
        }
    }
}