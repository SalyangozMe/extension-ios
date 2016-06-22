//
//  ShareViewController.swift
//  SalyangozShareExtension
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import Social
import SalyangozKit
import MobileCoreServices

class ShareViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var urlAttachmentProvider: NSItemProvider?
    var registeredIdentifier: CFString?
    
    override func beginRequestWithExtensionContext(context: NSExtensionContext) {
        super.beginRequestWithExtensionContext(context)
        if let input = context.inputItems as? [NSExtensionItem]{
            if let attachments = input[0].attachments{
                urlAttachmentProvider = attachments[0] as? NSItemProvider
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.masksToBounds = true
        
        
        if let provider = urlAttachmentProvider{
            let completionHandler: NSItemProviderCompletionHandler = { (result: NSSecureCoding?, error: NSError!) in
                if error == nil {
                    if let url = result as? NSURL{
                        self.sharePage("", url: url.absoluteString)
                    }else{
                        self.setMessageLabelText(NSLocalizedString("Error!", comment: ""))
                    }
                }else{
                    self.setMessageLabelText(NSLocalizedString("Error!", comment: ""))
                }
            }
            
            if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String){
                
                provider.loadItemForTypeIdentifier(kUTTypeURL as String,
                                                     options: nil,
                                                     completionHandler: completionHandler)
                
            }else if provider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String){
                provider.loadItemForTypeIdentifier(kUTTypePropertyList as String,
                                                   options: nil,
                                                   completionHandler: completionHandler)
            }else{
                self.setMessageLabelText(NSLocalizedString("Error!", comment: ""))
            }
        }else{
            self.setMessageLabelText(NSLocalizedString("Error!", comment: ""))
        }
    }
    
    func sharePage(title: String?, url: String?){
        guard let title = title else { return }
        guard let url = url else { return }
        if DataManager.sharedManager.isLoggedIn(){
            let post = Post(title: title, url: NSURL(string: url)!)
            SalyangozAPI.sharedAPI.sharePost(post, completion: { [unowned self] (success: Bool) in
                if success{
                    self.setMessageLabelText(NSLocalizedString("Shared!", comment: ""))
                }else{
                    self.setMessageLabelText(NSLocalizedString("Error!", comment: ""))
                }
            })
        }else{
            self.setMessageLabelText(NSLocalizedString("Please login first!", comment: ""))
        }
    }
    
    func setMessageLabelText(message:String){
        dispatch_async(dispatch_get_main_queue(), {
            self.messageLabel.text = message
        })
        self.complete()
    }
    
    func complete(delay: Double = 1){
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
        }
    }

}
