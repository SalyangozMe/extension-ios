//
//  LoginResponse.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

public class SessionUser: NSObject, NSCoding, UserProtocol, Mappable{
    public var userName: String?
    public var profileImage: String?
    var userId: Int = 0
    var token: String = ""
    
    override init(){}
    required public init?(_ map: Map){}
    
    public init(userId:Int, token:String){
        self.userId = userId
        self.token = token
        super.init()
    }
    
    required public convenience init?(coder decoder: NSCoder){
        
        let userId = decoder.decodeIntegerForKey("userId")
        guard let token = decoder.decodeObjectForKey("token") as? String else { return nil }
        
        self.init(userId: userId, token: token)
    }
    
    public func encodeWithCoder(coder: NSCoder){
        coder.encodeInteger(userId as Int, forKey: "userId")
        coder.encodeObject(token as String, forKey: "token")
    }
    
    public func mapping(map: Map) {
        userName <- map["user_name"]
        profileImage <- map["profile_image"]
    }
}