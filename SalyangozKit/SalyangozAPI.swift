//
//  SalyangozAPI.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 10/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

enum Router: URLRequestConvertible{
    static let baseURL = NSURL(string: "http://salyangoz.me/api/v1")!
    
    case Home(Int, String)
    case Login(String, String)
    case ShareToSalyangoz(Int, String, String, String)
    
    var URL: NSURL { return Router.baseURL.URLByAppendingPathComponent(route.path) }
    
    var route: (path: String, parameters: [String: AnyObject]?) {
        switch self {
        case .Login(let authToken, let authTokenSecret):
            return ("/login", ["token":authToken, "secret":authTokenSecret])
        case .Home(let userId, let userToken):
            return ("/home", ["id":userId, "token":userToken])
        case .ShareToSalyangoz(let userId, let token, let url, let title):
            return ("/post/add", ["id":userId, "token": "\(token)", "url":"\(url)", "title":"\(title)"])
        }
    }
    
    var method: Alamofire.Method{
        switch self{
        case .Home:
            return .GET
        case .Login:
            return .POST
        case .ShareToSalyangoz:
            return .POST
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let httpRequest = NSMutableURLRequest(URL: URL)
        httpRequest.HTTPMethod = method.rawValue
        return Alamofire.ParameterEncoding.JSON.encode(httpRequest, parameters: route.parameters).0
    }
}

public class SalyangozAPI{
    public static let sharedAPI = SalyangozAPI()
    
    public func login(authToken:String, authTokenSecret: String, completion:(response: User?, error: NSError?) -> Void){
        Alamofire.request(Router.Login(authToken, authTokenSecret)).responseJSON { (response: Response<AnyObject, NSError>) in
            if let jsonResult = response.result.value as? [String: AnyObject]{
                
                guard let status = jsonResult["status"] as? Bool else { return }
                if status{
                    guard let token = jsonResult["token"] as? String else { return }
                    guard let userId = jsonResult["id"] as? Int else { return }
                    
                    let user = User(userId: userId, token: token)
                    DataManager.sharedManager.createSession(user)
                    completion(response: user, error: response.result.error)
                }else{
                    completion(response: nil, error: response.result.error)
                }
            }
        }
    }
    
    public func shareToSalyangoz(url:String, title:String, completion:(response: String?, error: NSError?)->Void){
        guard let session = DataManager.sharedManager.getSession() else { return }
        let userId = session.userId
        let token  = session.token
        
        
        Alamofire.request(Router.ShareToSalyangoz(userId, token, url, title)).responseString { (response:Response<String, NSError>) in
            print(response)
            completion(response: response.result.value, error: response.result.error)
        }
    }

}