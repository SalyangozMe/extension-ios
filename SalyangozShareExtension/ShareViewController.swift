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
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        SalyangozAPI.sharedAPI.shareToSalyangoz(url, title: title) { (response, error) in
            self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
        }
    }

}
