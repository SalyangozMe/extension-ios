//
//  FeedUser.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

public class FeedUser: NSObject, UserProtocol, Mappable{
    public var userName: String?
    public var profileImage: String?
    
    required public init?(_ map: Map){}
    
    public func mapping(map: Map) {
        userName <- map["user_name"]
        profileImage <- map["profile_image"]
    }
}