//
//  ViewController.swift
//  PFSocialNetTest
//
//  Created by Lego on 8/22/17.
//  Copyright © 2017 PFSoft. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin
import LinkedinSwift

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var faceBookBtn: UIButton!
    @IBOutlet weak var googleIn: GIDSignInButton!
    @IBOutlet weak var linkedinBtn: UIButton!
    @IBOutlet weak var infoTextField: UITextField!

//     You still need to set appId and URLScheme in Info.plist, follow this instruction: https://developer.linkedin.com/docs/ios-sdk
    
    
    
    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "782sln0rngghxx", clientSecret: "RdJ9diAq9lq5Jze1", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://protrader.com/"))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkedinBtn.setImage(UIImage(named:"linkedinBtn"), for: .normal)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            print("sign in with Goole SUCCESS")
        } else {
            print("\(error.localizedDescription)")
        }
    }


    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            print("sign in with Goole SUCCESS")
        } else {
            print("\(error.localizedDescription)")
        }
    }

    func signInGoogle(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
           print("sign in with Goole SUCCESS")
        } else {
            print("\(error.localizedDescription)")
        }
    }

    @IBAction func signInGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        infoTextField.text = "loginID " + GIDSignIn.sharedInstance().clientID

    }

    @IBAction func signInFaceBook(_ sender: UIButton) {
        if let fbAccessToken = FacebookCore.AccessToken.current {
            infoTextField.text = "facebook" + fbAccessToken.authenticationToken
        } else {
            let loginManager = LoginManager()
            loginManager.logIn([.publicProfile, .email, .userFriends], viewController: self) { loginResult in
                switch loginResult {

                case .failed(let error):
                    print(error)
                    break
                case .cancelled:
                    print("User cancelled login.")
                    break
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("Logged in! \(grantedPermissions) \(accessToken) \(declinedPermissions)")

                    // Save Current UserInfo
                    let params = ["fields": "id,name,email,picture"]
                    let graphRequest = GraphRequest(graphPath: "me", parameters: params)
                    graphRequest.start { (urlResponse, requestResult) in
                        switch requestResult {
                        case .failed(let error):
                            print(error)
                        case .success(let graphResponse):
                            if let responseDictionary = graphResponse.dictionaryValue {
                                print("\(String(describing: graphResponse.dictionaryValue))")
                                UserDefaults.standard.set(responseDictionary, forKey: "userInfo")
                            }
                        }
                    }
                    break
                }
            }
        }
    }

     // linkedin:
    
    @IBAction func signInLinkedIn(_ sender: Any) {
        /**
         *  Yeah, Just this simple, try with Linkedin installed and without installed
         *
         *   Check installed if you want to do different UI: linkedinHelper.isLinkedinAppInstalled()
         *   Access token later after login: linkedinHelper.lsAccessToken
         */
        
        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
            print("Login success lsToken: \(lsToken)")
            self.requestProfile()
            }, error: { [unowned self] (error) -> Void in
                
               print("Encounter error: \(error.localizedDescription)")
            }, cancel: { [unowned self] () -> Void in
                
                print("User Cancelled!")
        })
    }
    
    
    @IBAction func requestProfile() {
        
        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            
            print("Request success with response: \(response)")
            
        }) { [unowned self] (error) -> Void in
            
            print("Encounter error: \(error.localizedDescription)")
        }
    }
}

