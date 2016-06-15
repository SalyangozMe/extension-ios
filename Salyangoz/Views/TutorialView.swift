//
//  TutorialView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 14/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit

class TutorialView: UIViewController{
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tutorialImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tutorialImageHeightConstraint: NSLayoutConstraint!
    var item: TutorialStruct?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let item = item{
            switch item.type {
            case .Cover:
                tutorialImageWidthConstraint.constant = item.image.size.width
                tutorialImageHeightConstraint.constant = item.image.size.height
            case .Normal:
                let ratio = item.image.size.width / item.image.size.height
                tutorialImageWidthConstraint.constant = 300
                tutorialImageHeightConstraint.constant = 300 / ratio
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = item{
            label.text = item.text
            imageView.image = item.image
            if 0 != item.order{
                stepLabel.hidden = false
                stepLabel.text = "Step \(item.order):"
            }else{
                stepLabel.hidden = true
            }
        }
    }
}