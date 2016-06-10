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

public class User: NSObject, NSCoding{
    var userId: Int = 0
    var token: String = ""
    
    required public convenience init?(coder decoder: NSCoder){
        
        let userId = decoder.decodeIntegerForKey("userId")
        guard let token = decoder.decodeObjectForKey("token") as? String else { return nil }
        
        self.init(userId: userId, token: token)
    }
    
    override init(){}
    
    public init(userId:Int, token:String){
        self.userId = userId
        self.token = token
        super.init()
    }
    
    public func encodeWithCoder(coder: NSCoder){
        coder.encodeInteger(userId as Int, forKey: "userId")
        coder.encodeObject(token as String, forKey: "token")
    }
}