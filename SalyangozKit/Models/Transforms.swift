//
//  Transforms.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 13/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import Foundation
import ObjectMapper

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