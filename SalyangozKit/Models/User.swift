//
//  User.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 13/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

public class User: NSObject, NSCoding, Mappable{
    public var userId: Int?
    public var token: String?
    public var username: String?
    public var profileImageURL: NSURL?
    public var posts: [Post]?
    
    public init(userId:Int, token:String){
        self.userId = userId
        self.token = token
        super.init()
    }
    
    //MARK: NSCoding Protocol Methods
    required public convenience init?(coder decoder: NSCoder){
        let userId = decoder.decodeIntegerForKey("userId")
        guard let token = decoder.decodeObjectForKey("token") as? String else { return nil }
        
        self.init(userId: userId, token: token)
    }
    
    public func encodeWithCoder(coder: NSCoder){
        guard let token = token else { return }
        guard let userId = userId else { return }
        
        coder.encodeObject(token as String, forKey: "token")
        coder.encodeInteger(userId as Int, forKey: "userId")
    }
    
    //MARK: Mappable Protocol Methods
    required public init?(_ map: Map){}
    
    public func mapping(map: Map) {
        let profileImageTransform = TransformOf<NSURL, String>(fromJSON:{ (value: String?) -> NSURL? in
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
        
        userId <- map["id"]
        token <- map["token"]
        username <- map["user_name"]
        profileImageURL <- (map["profile_image"], profileImageTransform)
        posts <- map["posts"]
    }
}