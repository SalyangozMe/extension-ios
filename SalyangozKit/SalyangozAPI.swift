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
    static let baseURL = NSURL(string: "https://salyangoz.me")!
    static let baseServiceURL = NSURL(string: "https://salyangoz.me/api/v1/mobile")!
    
    case Recent
    case Home(Int, String)
    case Login(String, String)
    case ShareToSalyangoz(Int, String, String, String)
    
    var URL: NSURL {
        switch self{
        case .Recent:
            return Router.baseURL.URLByAppendingPathComponent(route.path)
        default:
            return Router.baseServiceURL.URLByAppendingPathComponent(route.path)
        }
        
    }
    
    var route: (path: String, parameters: [String: AnyObject]?) {
        switch self {
        case .Login(let authToken, let authTokenSecret):
            return ("/login", ["token":authToken, "secret":authTokenSecret])
        case .Recent:
            return ("/recent.json", nil)
        case .Home(let userId, let userToken):
            return ("/posts/home", ["id":userId, "token":userToken])
        case .ShareToSalyangoz(let userId, let token, let url, let title):
            return ("/posts", ["id":userId, "token": "\(token)", "url":"\(url)", "title":"\(title)"])
        }
    }
    
    var method: Alamofire.Method{
        switch self{
        case .Recent:
            return .GET
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
        httpRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        return Alamofire.ParameterEncoding.JSON.encode(httpRequest, parameters: route.parameters).0
    }
}

public class SalyangozAPI{
    public static let sharedAPI = SalyangozAPI()
    
    public func login(authToken:String, authTokenSecret: String, completion:(success: Bool) -> Void){
        Alamofire.request(Router.Login(authToken, authTokenSecret)).responseObject { (response:Response<LoginResponse, NSError>) in
            switch response.result{
            case .Success:
                if let loginResponse = response.result.value{
                    let user = SessionUser(userId: loginResponse.userId, token: loginResponse.token)
                    DataManager.sharedManager.createSession(user)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(success: true)
                    })
                }
            case .Failure(let error):
                dispatch_async(dispatch_get_main_queue(), {
                    completion(success: false)
                })
                print(error.localizedDescription)
            }
        }
    }
    
    public func shareToSalyangoz(url:String, title:String, completion:(success: Bool)->Void){
        guard let session = DataManager.sharedManager.getSession() else { return }
        let userId = session.userId
        let token  = session.token
        
        Alamofire.request(Router.ShareToSalyangoz(userId, token, url, title)).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
            dispatch_async(dispatch_get_main_queue(), { 
                switch response.result{
                case .Success:
                    completion(success:true)
                case .Failure(_):
                    completion(success:false)
                }
            })
        })
    }
    
    public func getRecentFeed(completion:(feed:[Post]?, error:NSError?)->Void){
        Alamofire.request(Router.Recent).responseArray(keyPath:"posts"){ (response: Response<[Post], NSError>) in
            
            switch response.result{
            case .Success:
                if let feed = response.result.value{
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(feed: feed, error: nil)
                    })
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(feed: nil, error: nil)
                    })
                }
            case .Failure(let error):
                print(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue(), {
                    completion(feed: nil, error: error)
                })
            }
        }
    }
}