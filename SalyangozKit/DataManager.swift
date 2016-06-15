//
//  DataManager.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 09/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import Foundation
import KeychainAccess

let kServiceIdentifier = "com.towerlabs.salyangoz.service-identifier"
let kUserSessionKey = "salyangozUserSession"
let kTutorialSeenKey = "salyangozTutorialSeen"

public enum TutorialItemType{
    case Cover
    case Normal
}

public struct TutorialStruct{
    public var text: String
    public var image: UIImage
    public var type: TutorialItemType
    public var order: Int
    
    init(text: String, image: UIImage, type: TutorialItemType, order: Int){
        self.type = type
        self.text = text
        self.order = order
        self.image = image
    }
}


public class DataManager{
    private let sharedKeychain = Keychain(service: kServiceIdentifier)
    public static let sharedManager = DataManager()
    
    private var tutorialTexts: [String] = {
        return ["Hello,\nWelcome to Salyangoz for iOS!",
                "To share links from iOS,\nOpen Safari on your iPhone or iPod touch",
                "Then tap the Share button",
                "And tap More",
                "Enable Salyangoz and tap done",
                "Now you can start sharing by logging in!"]
    }()
    
    private var tutorials: [TutorialStruct]?
    
    // MARK: Session Methods
    
    public func createSession(user: User){
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
    
    public func getSession() -> User?{
        do {
            if let userData: NSData = try sharedKeychain.getData(kUserSessionKey){
                NSKeyedUnarchiver.setClass(User.self, forClassName: "SalyangozKit.User")
                if let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as? User{
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
    
    public func setTutorialSeen(status:Bool){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSNumber(bool: status), forKey: kTutorialSeenKey)
        defaults.synchronize()
    }
    
    public func isTutorialSeen() -> Bool{
        guard let isSeenObject = NSUserDefaults.standardUserDefaults().objectForKey(kTutorialSeenKey) else { return false }
        let isSeen = isSeenObject.boolValue
        if (isSeen != nil) && (isSeen.boolValue){
            return true
        }
        return false
    }
    
    public func getTutorials() -> [TutorialStruct]?{
        if (tutorials == nil){
            tutorials = []
            for (index, text) in tutorialTexts.enumerate(){
                let tutorialImage: UIImage
                let aTutorial: TutorialStruct
                if index == 0{
                    tutorialImage = UIImage(named: "Salyangoz")!
                    aTutorial = TutorialStruct(text: text, image: tutorialImage, type: .Cover, order: index)
                }else{
                    tutorialImage = UIImage(named: "TutorialImage\(index).png")!
                    aTutorial = TutorialStruct(text: text, image: tutorialImage, type: .Normal, order:index)
                }
                tutorials?.append(aTutorial)
            }
        }
        return tutorials
    }
}