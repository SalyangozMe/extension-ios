//
//  DataManager.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation
import KeychainAccess

let serviceIdentifier = "com.towerlabs.salyangoz.service-identifier"
let loginResponseKey = "loginResponse"

public class DataManager{
    private let sharedKeychain = Keychain(service: serviceIdentifier)
    public static let sharedManager = DataManager()
    
    public func createSession(user: User){
        let loginResponseData = NSKeyedArchiver.archivedDataWithRootObject(user)
        do {
            try sharedKeychain.set(loginResponseData, key: loginResponseKey)
        }catch {
            print(error)
        }
    }
    
    public func isLoggedIn() -> Bool{
        do {
            if let _ = try sharedKeychain.getData(loginResponseKey){
                return true
            }else{
                return false
            }
        }catch {
            return false
        }
    }
    
    public func removeLoginResponse(){
        do {
            try sharedKeychain.remove(loginResponseKey)
        }catch {
            print(error)
        }
    }
    
    public func getSession() -> User?{
        do {
            if let userData: NSData = try sharedKeychain.getData(loginResponseKey){
                NSKeyedUnarchiver.setClass(User.self, forClassName: "SalyangozKit.User")
                if let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as? User{
                    print(user)
                    return user
                }
            }
        }catch {
            print(error)
            return nil
        }
        return nil
    }
}