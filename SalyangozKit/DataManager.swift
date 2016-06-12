//
//  DataManager.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation
import KeychainAccess

let kServiceIdentifier = "com.towerlabs.salyangoz.service-identifier"
let kUserSessionKey = "salyangozUserSession"
let kTutorialSeenKey = "salyangozTutorialSeen"

public class DataManager{
    private let sharedKeychain = Keychain(service: kServiceIdentifier)
    public static let sharedManager = DataManager()
    
    // MARK: Session Methods
    
    public func createSession(user: SessionUser){
        let loginResponseData = NSKeyedArchiver.archivedDataWithRootObject(user)
        do {
            try sharedKeychain.set(loginResponseData, key: kUserSessionKey)
        }catch {
            print(error)
        }
    }
    
    public func isLoggedIn() -> Bool{
        do {
            if let _ = try sharedKeychain.getData(kUserSessionKey){
                return true
            }else{
                return false
            }
        }catch {
            return false
        }
    }
    
    public func removeSession(){
        do {
            try sharedKeychain.remove(kUserSessionKey)
        }catch {
            print(error)
        }
    }
    
    public func getSession() -> SessionUser?{
        do {
            if let userData: NSData = try sharedKeychain.getData(kUserSessionKey){
                NSKeyedUnarchiver.setClass(SessionUser.self, forClassName: "SalyangozKit.SessionUser")
                if let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as? SessionUser{
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
    
    // MARK: Tutorial Methods
    
    public func setTutorialSeenStatus(status:Bool){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(status, forKey: kTutorialSeenKey)
    }
    
    public func isTutorialSeen() -> Bool{
        guard let isSeenObject = NSUserDefaults.standardUserDefaults().objectForKey(kTutorialSeenKey) else { return false }
        if let _ = isSeenObject.boolValue{
            return true
        }
        return false
    }
}