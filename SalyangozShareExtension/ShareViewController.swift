//
//  ShareViewController.swift
//  SalyangozShareExtension
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import UIKit
import SalyangozKit
import MobileCoreServices

class ShareViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        setupUI()
        loadItem()
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.15)
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.masksToBounds = true
    }
    
    func loadItem(){
        guard let provider = urlAttachmentProvider else {
            self.setMessageLabelText(NSLocalizedString("Internal Error(-1)!", comment: ""))
            return
        }
        
        let type = provider.registeredTypeIdentifiers[0] as! String
        
        let completionHandler: NSItemProviderCompletionHandler = { (result: NSSecureCoding?, error: NSError!) in
            if error == nil {
                
                if let urlString = result as? String{
                    self.sharePage("", url: urlString)
                }else if let urlString = result as? NSURL{
                    self.sharePage("", url: urlString.absoluteString)
                }else{
                    self.setMessageLabelText(NSLocalizedString("Internal Error(-3)!", comment: ""))
                }
                
            }else{
                self.setMessageLabelText(NSLocalizedString("Internal Error(-2)!", comment: ""))
            }
        }
        
        if self.isContentValid(type){
            provider.loadItemForTypeIdentifier(type,
                                               options: nil,
                                               completionHandler: completionHandler)
        }else{
            self.setMessageLabelText(NSLocalizedString("Unsupported Media!", comment: ""))
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
            self.activityIndicator.removeFromSuperview()
        })
        self.complete()
    }
    
    func complete(delay: Double = 1){
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
        }
    }
    
    func isContentValid(contentType: CFString) -> Bool{
        if contentType == kUTTypePlainText || contentType == kUTTypeURL || contentType == kUTTypePropertyList{
            return true
        }else{
            return false
        }
    }
}
