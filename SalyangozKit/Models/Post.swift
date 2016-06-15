//
//  Post.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 13/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

public class Post: NSObject, Mappable{
    public var url: NSURL?
    public var owner: User?
    public var postId: Int?
    public var title: String?
    public var visitCount: Int?
    public var updatedAt: NSDate?
    
    lazy var dateFormatter: NSDateFormatter = {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        return dateFormatter
    }()
    
    public init(title: String, url: NSURL){
        super.init()
        self.title = title
        self.url = url
    }
    
    required public init?(_ map: Map){}
    
    public func mapping(map: Map) {
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

        postId <- map["id"]
        url <- (map["url"], transformURL)
        title <- map["title"]
        visitCount <- map["visit_count"]
        updatedAt <- (map["updated_at"], transformUpdatedAt)
        owner <- map["user"]
    }
}