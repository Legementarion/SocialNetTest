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

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var faceBookBtn: UIButton!
    @IBOutlet weak var googleIn: GIDSignInButton!
    @IBOutlet weak var linkedinBtn: UIButton!
    @IBOutlet weak var infoTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func signInGoogle(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                      withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // ...
        } else {
//            println("\(error.localizedDescription)")
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
            loginManager.loginBehavior = LoginBehavior.web
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

    @IBAction func signInLinkedIn(_ sender: Any) {
        infoTextField.text = "linkedIn"
    }

}

