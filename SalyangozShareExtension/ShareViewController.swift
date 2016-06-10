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
                        
                        self.sharePage(url, title: title)
                    }
                    
                    attachment.loadItemForTypeIdentifier(kUTTypePropertyList as String,
                                                         options: nil,
                                                         completionHandler: completionHandler);
                }
            }
        }
        
        
    }
    
    func sharePage(url: String, title: String){
        if DataManager.sharedManager.isLoggedIn(){
            SalyangozAPI.sharedAPI.shareToSalyangoz(url, title: title) {  [unowned self] (response, error) in
                if let _ = response{
                    self.messageLabel.text = NSLocalizedString("Shared!", comment: "")
                }else{
                    self.messageLabel.text = NSLocalizedString("Error!", comment: "")
                }
                self.complete()
            }
        }else{
            self.messageLabel.text = NSLocalizedString("Please login first!", comment: "")
            self.complete()
        }
    }
    
    func complete(){
        let delayInSeconds = 1.5
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            dispatch_async(dispatch_get_main_queue(), {
                self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
            })
        }
    }

}
