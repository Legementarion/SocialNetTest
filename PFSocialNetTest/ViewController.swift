//
//  ViewController.swift
//  PFSocialNetTest
//
//  Created by Lego on 8/22/17.
//  Copyright © 2017 PFSoft. All rights reserved.
//

import UIKit
import GoogleSignIn

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
        infoTextField.text = "loginID "+GIDSignIn.sharedInstance().clientID

    }
    @IBAction func signInFaceBook(_ sender: UIButton) {
        infoTextField.text = "facebook"
    }

    @IBAction func signInLinkedIn(_ sender: Any) {
        infoTextField.text = "linkedIn"
    }

}

