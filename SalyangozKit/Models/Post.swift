//
//  FeedItem.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

public class Post: NSObject, Mappable{
    public var itemId: Int?
    public var title: String?
    public var visitCount: Int?
    public var feedUser: FeedUser?
    public var url: NSURL?
    public var updatedAt: NSDate?
    
    lazy var dateFormatter: NSDateFormatter = {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        return dateFormatter
    }()
    
    required public init?(_ map: Map){}
    
    public func mapping(map: Map) {
        let transformURL = TransformOf<NSURL, String>(fromJSON:{ (value: String?) -> NSURL? in
            if let value = value{
                return NSURL(string: value)
            }else{
                return nil
            }
        }, toJSON: {(value: NSURL?) -> String? in
            if let value = value{
                return value.absoluteString
            }
            return nil
        })
        
        let transformUpdatedAt = TransformOf<NSDate, String>(fromJSON:{ (value: String?) -> NSDate? in
            if let value = value{
                return self.dateFormatter.dateFromString(value)
            }else{
                return nil
            }
        }, toJSON: {(value: NSDate?) -> String? in
            if let value = value{
                return self.dateFormatter.stringFromDate(value)
            }
            return nil
        })
        
        itemId <- map["id"]
        url <- (map["url"], transformURL)
        title <- map["title"]
        visitCount <- map["visit_count"]
        updatedAt <- (map["updated_at"], transformUpdatedAt)
        feedUser <- map["user"]
    }
}