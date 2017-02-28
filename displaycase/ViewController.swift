//
//  ViewController.swift
//  displaycase
//
//  Created by JuanPa Villa on 2/27/17.
//  Copyright © 2017 JuanPa Villa. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }


    @IBAction func fbBttnPressed(sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (facebookResult, facebookError) in
            
            if facebookError != nil {
                print("Facebook login failed. Error: ")
            } else {
                
                let accessToken = FBSDKAccessToken.current().tokenString
                print("Successfully logged in with Facebook. \(accessToken)")
            }
            
        }
        
    }
    

}

