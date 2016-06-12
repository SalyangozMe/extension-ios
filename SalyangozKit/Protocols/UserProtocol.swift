//
//  UserProtocol.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 11/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation

public protocol UserProtocol{
    var userName: String? {get set}
    var profileImage: String? {get set}
    //optional var profileImageURL: NSURL{ get }
}

public extension UserProtocol{
    public func getProfileImageURL() -> NSURL?{
        if let profileImageURLString = profileImage {
            return NSURL(string: profileImageURLString)
        }
        return nil
    }
}