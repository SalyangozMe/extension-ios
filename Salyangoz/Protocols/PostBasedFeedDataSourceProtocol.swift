//
//  PostBasedFeedDataSourceProtocol.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 27/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import Foundation
import SalyangozKit

enum PostBasedFeedType: String{
    case Recent = "Recent"
    case Popular = "Popular"
}

protocol PostBasedFeedDataSourceProtocol{
    var beforeCompletionHandler: () -> Void { get }
    var afterCompletionHandler: postBasedFeedCompletionHandlerType { get }
    
    var feedType: PostBasedFeedType { get }
    
    func getData()
}

protocol PostBasedFeedDelegateProtocol{
    func beforeCompletionHandler()
    func afterCompletionHandler(feed:[Post]?, error:NSError?)
}

extension PostBasedFeedDataSourceProtocol where Self: NSObject{

    func getData(){

        beforeCompletionHandler()
        
        switch feedType {
        case .Recent:
            SalyangozAPI.sharedAPI.getRecentFeed(afterCompletionHandler)
        case .Popular:
            SalyangozAPI.sharedAPI.getPopularFeed(afterCompletionHandler)
        }
    }
}