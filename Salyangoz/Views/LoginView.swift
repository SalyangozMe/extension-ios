//
//  LoginView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 08/06/16.
//  Copyright © 2016 Salyangoz All rights reserved.
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
        self.loginWithTwitterButton.logInCompletion = {(session, error: NSError?) in
            if let unwrappedSession = session {
                self.makeLoginToSalyangozService(unwrappedSession.authTokenSecret, authTokenSecret: unwrappedSession.authToken)
            } else if let error = error{
                let firstAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                self.alert("An error occured", message: error.localizedDescription, action: firstAction)
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
                let firstAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                self.alert("Can not log in", message: "Please try again later.", action: firstAction)
            }
        })
    }
}

