//
//  ShareViewController.swift
//  SalyangozShareExtension
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import Social
import SalyangozKit
import MobileCoreServices

class ShareViewController: UIViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.masksToBounds = true
        
        guard let context = self.extensionContext else { return }
        guard let inputItems = context.inputItems as? [NSExtensionItem] else { return }
        
        for item: NSExtensionItem in inputItems{
            guard let attachments = item.attachments as? [NSItemProvider] else { break }
            
            for attachment: NSItemProvider in attachments{
                if attachment.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                    
                    let completionHandler: NSItemProviderCompletionHandler = { (result: NSSecureCoding?, error: NSError!) in
                        guard let resultsDict = result as? NSDictionary else { return }
                        guard let preprocessingResults = resultsDict[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                        guard let url = preprocessingResults["URL"] as? String else { return }
                        guard let title = preprocessingResults["title"] as? String else { return }
                        
                        self.sharePage(title, url: url)
                    }
                    
                    attachment.loadItemForTypeIdentifier(kUTTypePropertyList as String,
                                                         options: nil,
                                                         completionHandler: completionHandler);
                }
            }
        }
        
        
    }
    
    func sharePage(title: String, url: String){
        if DataManager.sharedManager.isLoggedIn(){
            let post = Post(title: title, url: NSURL(string: url)!)
            SalyangozAPI.sharedAPI.sharePost(post, completion: { [unowned self] (success: Bool) in
                if success{
                    self.setMessageLabelText(NSLocalizedString("Shared!", comment: ""))
                }else{
                    self.setMessageLabelText(NSLocalizedString("Error!", comment: ""))
                }
                self.complete()
            })
        }else{
            self.setMessageLabelText(NSLocalizedString("Please login first!", comment: ""))
            self.complete()
        }
    }
    
    func setMessageLabelText(message:String){
        dispatch_async(dispatch_get_main_queue(), {
            self.messageLabel.text = message
        })
    }
    
    func complete(){
        let delayInSeconds = 1.5
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
        }
    }

}
