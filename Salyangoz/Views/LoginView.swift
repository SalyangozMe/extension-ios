//
//  LoginView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 08/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import TwitterKit
import SalyangozKit

class LoginView: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginWithTwitterButton: TWTRLogInButton!
    @IBOutlet weak var continueAsGuestButton: UIButton!
    
    @IBAction func continueAsGuest(sender: AnyObject) {
        Wireframe.sharedWireframe.showTabBarWithoutLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeLoginButton()
    }
    
    // MARK: Private Helper Methods
    
    func initializeLoginButton(){
        self.loginWithTwitterButton.logInCompletion = {(session, error) in
            if let unwrappedSession = session {
                self.makeLoginToSalyangozService(unwrappedSession.authToken, authTokenSecret: unwrappedSession.authTokenSecret)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
            
        }
    }
    
    func makeLoginToSalyangozService(authToken: String, authTokenSecret: String){
        self.activityIndicator.show()
        SalyangozAPI.sharedAPI.login(authToken, authTokenSecret: authTokenSecret, completion: { (success) in
            self.activityIndicator.hide()
            if success{
                Wireframe.sharedWireframe.showTabBarWithLogin()
            }else{
                print("Can't log in.")
            }
        })
    }
}

