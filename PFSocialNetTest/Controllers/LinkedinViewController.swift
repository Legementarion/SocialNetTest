//
//  LinkedinViewController.swift
//  PFSocialNetTest
//
//  Created by DmitriyPuchka on 8/25/17.
//  Copyright © 2017 PFSoft. All rights reserved.
//

import Foundation

class LinkedinViewController: UIViewController, UIWebViewDelegate {

    // MARK: IBOutlet Properties
    @IBOutlet weak var webView: UIWebView!


    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Constants

    let linkedInKey = "782sln0rngghxx"

    let linkedInSecret = "RdJ9diAq9lq5Jze1"

    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"

    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"



    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        startAuthorization()
    }


    // MARK: Custom Functions

    func startAuthorization() {
        // Specify the response type which should always be "code".
        let responseType = "code"

        // Set the redirect URL. Adding the percent escape characthers is necessary.
        let redirectURL = "https://com.pfsoft.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!

        // Create a random string based on the time intervale (it will be in the form linkedin12345679).
        let state = "linkedin\(Int(Date().timeIntervalSince1970))"

        // Set preferred scope.
        let scope = "r_basicprofile"


        // Create the authorization URL string.
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"

        print(authorizationURL)


        // Create a URL request and load it in the web view.
        let request = URLRequest(url: URL(string: authorizationURL)!)
        webView.loadRequest(request)
    }



    func requestForAccessToken(_ authorizationCode: String) {
        let grantType = "authorization_code"

        let redirectURL = "https://com.pfsoft.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!

        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"

        // Convert the POST parameters into a NSData object.
        let postData = postParams.data(using: String.Encoding.utf8)


        // Initialize a mutable URL request object using the access token endpoint URL string.
        let request = NSMutableURLRequest(url: URL(string: accessTokenEndPoint)!)

        // Indicate that we're about to make a POST request.
        request.httpMethod = "POST"

        // Set the HTTP body using the postData object created above.
        request.httpBody = postData

        // Add the required HTTP header field.
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")


        // Initialize a NSURLSession object.
        //let session = URLSession(configuration: URLSessionConfiguration.default)

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            //Get the HTTP status code of the request.
            let statusCode = (response as! HTTPURLResponse).statusCode

            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]

                    let accessToken = dataDictionary["access_token"] as! String

                    //                                UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                    //                                UserDefaults.standard.synchronize()

                    DispatchQueue.main.async(execute: { () -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }

        task.resume()

    }


    // MARK: UIWebViewDelegate Functions

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!
        print(url)

        if url.host == "com.pfsoft.linkedin.oauth" {
            if url.absoluteString.range(of: "code") != nil {
                // Extract the authorization code.
                let urlParts = url.absoluteString.components(separatedBy: "?")
                let code = urlParts[1].components(separatedBy: "=")[1]

                requestForAccessToken(code)
            }
        }

        return true
    }


}
