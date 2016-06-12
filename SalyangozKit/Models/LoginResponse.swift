//
//  LoginResponse.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class LoginResponse: Mappable{
    var status: Bool = false
    var userId: Int = 0
    var token: String = ""
    
    required init?(_ map: Map){}
    
    func mapping(map: Map) {
        status <- map["status"]
        userId <- map["userId"]
        token <- map["token"]
    }
}