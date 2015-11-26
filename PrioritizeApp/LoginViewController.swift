//
//  LoginViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/7/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit
import Parse
import Spring
import TPKeyboardAvoiding

class LoginViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {

    @IBOutlet var usernameTextField: DesignableTextField!
    @IBOutlet var passwordTextField: DesignableTextField!
    @IBOutlet var loginButton: DesignableButton!
    @IBOutlet weak var lineView: DesignableView!
    @IBOutlet weak var usernameImageView: SpringImageView!
    @IBOutlet weak var passwordImageView: SpringImageView!
    var originalCenter: CGPoint!
    var transitionManager = TransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapReceived")
        view.addGestureRecognizer(tapGestureRecognizer)
        
        slideUp()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTextField.endEditing(true)
        usernameTextField.resignFirstResponder()
        usernameTextField.layoutIfNeeded()
        
        if textField === self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
            return false
        } else if textField === self.passwordTextField {
            loginPressed(passwordTextField)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        usernameTextField.resignFirstResponder()
        usernameTextField.layoutIfNeeded()
    }
    
    func tapReceived() {
        usernameTextField.endEditing(true)
        usernameTextField.resignFirstResponder()
        usernameTextField.layoutIfNeeded()
        
        passwordTextField.endEditing(true)
        passwordTextField.resignFirstResponder()
        passwordTextField.layoutIfNeeded()
    }
    
    func showLoad() {
        Loading.start()
    }
    
    func hideLoad() {
        Loading.stop()
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        showLoad()
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text, block: { (user,error) in
            
            if error != nil {
                self.shakeMainView()
                SoundPlayer().playRejected()
                self.hideLoad()
            } else {
                let currentUser = PFUser.currentUser()
                let email = currentUser.email
                
                if currentUser["emailVerified"] == nil {
                    self.showVerificationAlert()
                    self.hideLoad()
                } else {
                    let verified = currentUser["emailVerified"] as! Bool
                    
                    if verified == false {
                        let alert = UIAlertView(title:"Oops!", message:"You need to verify your account. The verificaition email was sent to: \(email)", delegate: self, cancelButtonTitle:"Got it!")
                        alert.show()
                        self.hideLoad()
                    } else {
                        self.performSegueWithIdentifier("loggedIn", sender: self)
                        self.passwordTextField.text = nil
                        self.usernameTextField.text = nil
                        self.hideLoad()
                    }
                }
            }
        })
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        let email = alertView.textFieldAtIndex(0)?.text!
        if email == "" {}
            
        else {
            let currentUser = PFUser.currentUser()
            currentUser.setValue(email, forKey: "email")
            currentUser.saveInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {}
                else {
                    let alert = UIAlertView(title:"Oops!", message:"The email that you have entered is already connected with another account.", delegate: self, cancelButtonTitle: "Got it!")
                    alert.show()
                }
            }
        }
    }
    
    func showVerificationAlert() {
        let verificationAlert = UIAlertView(title:"Enter your email", message:"This email will be used for verification purposes only.", delegate: self, cancelButtonTitle:"Done")
        verificationAlert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        verificationAlert.show()
        
        let verificationTextField = verificationAlert.textFieldAtIndex(0)
        verificationTextField!.placeholder = "Email"
        verificationTextField!.keyboardType = UIKeyboardType.EmailAddress
    }
    
    func shakeMainView() {
        usernameTextField.animation = "shake"
        passwordTextField.animation = "shake"
        loginButton.animation = "shake"
        lineView.animation = "shake"
        usernameImageView.animation = "shake"
        passwordImageView.animation = "shake"
        
        usernameTextField.animate()
        passwordTextField.animate()
        loginButton.animate()
        lineView.animate()
        usernameImageView.animate()
        passwordImageView.animate()
    }
    
    func slideUp() {
        usernameTextField.animation = "slideUp"
        usernameTextField.damping = 1
        usernameTextField.delay = 0.1
        
        passwordTextField.animation = "slideUp"
        passwordTextField.damping = 1
        passwordTextField.delay = 0.2
        
        loginButton.animation = "slideUp"
        loginButton.damping = 1
        loginButton.delay = 0.3
        
        lineView.animation = "slideUp"
        lineView.damping = 1
        lineView.delay = 0.2
        
        usernameImageView.animation = "slideUp"
        usernameImageView.damping = 1
        usernameImageView.delay = 0.1
        
        passwordImageView.animation = "slideUp"
        passwordImageView.damping = 1
        passwordImageView.delay = 0.2
        
        usernameTextField.animate()
        passwordTextField.animate()
        loginButton.animate()
        lineView.animate()
        usernameImageView.animate()
        passwordImageView.animate()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createAccount" {
            let vc = segue.destinationViewController as! CreateAccountTableViewController
            vc.transitioningDelegate = transitionManager
        }
    }
}
