//
//  SalyangozAPI.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 10/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public typealias booleanCompletionHandlerType = (Bool)->Void

enum Router: URLRequestConvertible{
    static let baseURL = NSURL(string: "https://salyangoz.me")!
    static let baseServiceURL = NSURL(string: "https://salyangoz.me/api/v1/mobile")!
    
    case Recent
    case Home(String)
    case Login(String, String)
    case ShareToSalyangoz(Int, String, String, String)
    case MarkAsVisited(Int)
    
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
            return ("/login", ["token":authToken, "secret":authTokenSecret, "type": "ios"])
        case .Recent:
            return ("/recent", nil)
        case .Home(let userToken):
            return ("/posts/home", ["token":userToken])
        case .ShareToSalyangoz(let userId, let token, let url, let title):
            return ("/posts", ["id":userId, "token": "\(token)", "url":"\(url)", "title":"\(title)"])
        case .MarkAsVisited(let postId):
            return ("/posts/\(postId)/visit", nil)
        }
    }
    
    var method: Alamofire.Method{
        switch self{
        case .Recent:
            return .GET
        case .Home:
            return .POST
        case .Login:
            return .POST
        case .ShareToSalyangoz:
            return .POST
        case .MarkAsVisited:
            return .GET
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
    
    func feedsCompletionHandler<T>(response: Alamofire.Response<[T], NSError>, completion:(feed:[T]?, error:NSError?)->Void){
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
    
    func booleanCompletionHandler(response: Response<AnyObject, NSError>, completion: booleanCompletionHandlerType?){
        if let completion = completion{
            dispatch_async(dispatch_get_main_queue(), {
                switch response.result{
                case .Success:
                    completion(true)
                case .Failure(_):
                    completion(false)
                }
            })
        }
    }
    
    //MARK: Endpoints
    
    public func login(authToken:String, authTokenSecret: String, completion:(success: Bool) -> Void){
        Alamofire.request(Router.Login(authToken, authTokenSecret)).responseObject { (response:Response<User, NSError>) in
            switch response.result{
            case .Success:
                if let user: User = response.result.value{
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
    
    public func sharePost(post: Post, completion:(success: Bool)->Void){
        guard let session: User = DataManager.sharedManager.getSession() else { return }
        guard let userId = session.userId else { return }
        guard let token  = session.token else { return }
        guard let url = post.url else { return }
        guard let title = post.title else { return }
        
        Alamofire.request(Router.ShareToSalyangoz(userId, token, url.absoluteString, title)).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
            self.booleanCompletionHandler(response, completion: completion)
        })
    }
    
    public func getRecentFeed(completion:(feed:[Post]?, error:NSError?)->Void){
        Alamofire.request(Router.Recent).responseArray(keyPath:"posts"){ (response: Response<[Post], NSError>) in
            self.feedsCompletionHandler(response, completion: completion)
        }
    }
    
    public func getHomeFeed(completion:(feed:[User]?, error:NSError?)->Void){
        guard let sessionUser = DataManager.sharedManager.getSession() else { return }
        guard let token = sessionUser.token else { return }
        
        Alamofire.request(Router.Home(token)).responseArray(completionHandler: { (response:Response<[User], NSError>) in
            self.feedsCompletionHandler(response, completion: completion)
        })
    }
    
    public func markPostAsVisited(post: Post, completion: booleanCompletionHandlerType?){
        if let postId = post.postId{
            Alamofire.request(Router.MarkAsVisited(postId)).responseJSON { (response: Response<AnyObject, NSError>) in
                self.booleanCompletionHandler(response, completion: completion)
            }
        }
    }
}