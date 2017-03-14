//
//  ViewController.swift
//  displaycase
//
//  Created by JuanPa Villa on 2/27/17.
//  Copyright © 2017 JuanPa Villa. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            
            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
        }
        
    }
    
    


    @IBAction func fbBttnPressed(sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (facebookResult, facebookError) in
            
            if facebookError != nil {
                print("Facebook login failed. Error: ")
            } else {
                
//                let accessToken = FBSDKAccessToken.current().tokenString
//                print("Successfully logged in with Facebook. \(accessToken)")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                
                    
                    FIRAuth.auth()?.signIn(with: credential, completion: { (userData, error) in
                        //
                        if error != nil {
                            print("Sign in failed: \(error)")
                        } else {
                            
                            let user = ["provider": "facebook", "blah": "test"]
                            print(userData?.providerID.description ?? "Error")

                            let uid = userData?.uid
                            
                            DataService.ds.createFirebaseUser(uid: uid!, user: user)

                            
                            UserDefaults.standard.set(uid, forKey: KEY_UID)
                            print(uid!)
                            
                            
                            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                        }
                        
                    })
                    
                
                
                
                
                
            }
            
        }
        
    }
    
    
    
    
    @IBAction func attemptLogin(sender: UIButton!) {
        
        if let email = emailField.text, email != "", let pwd = passwordField.text, pwd != "" {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                //
                
                if error != nil {
                    print(error!)
                    let nserror = error as! NSError
                    print("code: \(nserror.code)")
                    
                    if nserror.code == STATUS_ACCOUNT_NONEXIST {
                        
                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (usr, err) in
                            //
                            if err != nil {
                                print(err!)
                                self.showErrorAlert(title: "Could not create account", msg: "Problem creating account. Please try something else.")
                            } else {
                                
                               
                                
                                FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: nil)
                                
                                let user = ["provider":"password", "blah":"emailtest"]
                                DataService.ds.createFirebaseUser(uid: (usr?.uid)!, user: user)
                                
                                UserDefaults.standard.set(usr?.uid, forKey: KEY_UID)
                                
                                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                            
                        })
                    } else {
                        self.showErrorAlert(title: "Could not login", msg: "Please check your username and password")
                    }
                } else {
                    
                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
            
            
            
            
        } else {
            
            showErrorAlert(title: "Email and Password required", msg: "You must enter an email and a password")
        }
    }
    
    
    func showErrorAlert(title: String, msg: String) {
        //
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    

}

