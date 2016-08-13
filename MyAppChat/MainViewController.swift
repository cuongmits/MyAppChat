//
//  ViewController.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 7/22/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

//xu ly khi bam enter tu textbox1 va textbox2!!!

class MainViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //btnForgotPassword.skin(b: false) //false!
        
        isLogin()
        
        // Optional: Place the button in the center of your view.
        loginButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.9)
        self.view!.addSubview(loginButton)
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        loginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtnClicked(sender: AnyObject) {
        
        //Declaration for Indicator
        let alertActivity: UIAlertController = UIAlertController(title: "Please Wait", message: "\nConnecting to server", preferredStyle: .Alert)
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: alertActivity.view.bounds)
        indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        indicator.color = UIColor.blueColor()
        
        alertActivity.view.addSubview(indicator)
        indicator.userInteractionEnabled = false
        indicator.startAnimating()
        self.presentViewController(alertActivity, animated: true, completion: nil)
        
        FIRAuth.auth()?.signInWithEmail(txtUsername.text!, password: txtPassword.text!) { (user, error) in
            
            if (error == nil) {
                indicator.stopAnimating()
                alertActivity.dismissViewControllerAnimated(true, completion: nil)

                print("Successfully logged in!")
                
                self.gotoScreen()
                
            } else {
                //Declaration for Notification when login fail
                let alert = UIAlertController(title: "Notification", message: "Username or Password is wrong!", preferredStyle: .Alert)
                //add OK button
                let btnOK: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(btnOK)
                
                indicator.stopAnimating()
                alertActivity.dismissViewControllerAnimated(false, completion: {
                    self.presentViewController(alert, animated: false, completion: nil)
                })
                
                print("Fail logged in!")
            }
        }
        
    }

    @IBAction func forgotPasswordBtnClicked(sender: AnyObject) {
    }

    @IBAction func createAccountBtnClicked(sender: AnyObject) {
    }
    
    func isLogin() { //2 lan?
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                print("Logged in already")
                print(user.email)
                
                self.gotoScreen()
                
            } else {
                print("Not log in yet!")
            }
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User did logout")
    }
}

extension UIViewController {
    
    func gotoScreen() {
        let scr = self.storyboard?.instantiateViewControllerWithIdentifier("LoggedInScreen")
        if (scr != nil) {
            self.presentViewController(scr!, animated: true, completion: nil)
        } else {
            print("Error with switch screen!")
        }
    }
}