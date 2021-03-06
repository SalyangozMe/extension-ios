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
public typealias postBasedFeedCompletionHandlerType = (feed:[Post]?, error:NSError?)->Void

enum Router: URLRequestConvertible{
    static let baseURL = NSURL(string: "https://salyangoz.me")!
    static let baseServiceURL = NSURL(string: "https://salyangoz.me/api/v1/mobile")!
    
    case Recent
    case Popular
    case News(String)
    case Login(String, String)
    case ShareToSalyangoz(Int, String, String, String)
    case MarkPostAsVisited(Int, String)
    case ArchivePost(Int, String)
    
    var URL: NSURL {
        switch self{
        case .Recent, .Popular:
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
        case .ShareToSalyangoz(let userId, let token, let url, let title):
            return ("/posts", ["id":userId, "token": "\(token)", "url":"\(url)", "title":"\(title)"])
        case .MarkPostAsVisited(let postId, let token):
            return ("/posts/\(postId)/visit", ["token": token])
        case .News(let token):
            return ("/posts/new", ["token": "\(token)"])
        case .ArchivePost(let postId, let token):
            return ("/posts/\(postId)/archive", ["token": token])
        case .Popular:
            return ("/popular", nil)
        }
    }
    
    var method: Alamofire.Method{
        switch self{
        case .Recent, .MarkPostAsVisited, .Popular:
            return .GET
        case .Login, .ShareToSalyangoz, .ArchivePost, .News:
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
                    if let responseDict = response.result.value as? NSDictionary{
                        let success = responseDict["success"] as! Bool
                        if success{
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }else{
                        completion(false)
                    }
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
    
    public func getRecentFeed(completion: postBasedFeedCompletionHandlerType){
        Alamofire.request(Router.Recent).responseArray(keyPath:"posts"){ (response: Response<[Post], NSError>) in
            self.feedsCompletionHandler(response, completion: completion)
        }
    }
    
    public func getNewsFeed(completion:(feed:[User]?, error:NSError?)->Void){
        guard let sessionUser = DataManager.sharedManager.getSession() else { return }
        guard let token = sessionUser.token else { return }
        
        Alamofire.request(Router.News(token)).responseArray(completionHandler: { (response:Response<[User], NSError>) in
            self.feedsCompletionHandler(response, completion: completion)
        })
    }
    
    public func getPopularFeed(completion: postBasedFeedCompletionHandlerType){
        Alamofire.request(Router.Popular).responseArray(keyPath:"posts"){ (response: Response<[Post], NSError>) in
            self.feedsCompletionHandler(response, completion: completion)
        }
    }
    
    public func markPostAsVisited(post: Post, completion: booleanCompletionHandlerType?){
        guard let sessionUser = DataManager.sharedManager.getSession() else { return }
        guard let token = sessionUser.token else { return }
        
        if let postId = post.postId{
            Alamofire.request(Router.MarkPostAsVisited(postId, token)).responseJSON { (response: Response<AnyObject, NSError>) in
                self.booleanCompletionHandler(response, completion: completion)
            }
        }
    }
    
    public func archivePost(post: Post, completion: booleanCompletionHandlerType?){
        guard let sessionUser = DataManager.sharedManager.getSession() else { return }
        guard let token = sessionUser.token else { return }
        
        if let postId = post.postId{
            Alamofire.request(Router.ArchivePost(postId, token)).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                self.booleanCompletionHandler(response, completion: completion)
            })
        }
    }
}