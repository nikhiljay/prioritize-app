//
//  LoginViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/7/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameTextField: DesignableTextField!
    @IBOutlet var passwordTextField: DesignableTextField!
    @IBOutlet var loginButton: DesignableButton!
    @IBOutlet weak var lineView: DesignableView!
    @IBOutlet weak var usernameImageView: SpringImageView!
    @IBOutlet weak var passwordImageView: SpringImageView!
    var originalCenter: CGPoint!
    var keyboardDown: Bool!
    var transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardDown = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
                self.hideLoad()
            } else {
                self.performSegueWithIdentifier("loggedIn", sender: self)
                self.passwordTextField.text = nil
                self.usernameTextField.text = nil
            }
        })
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
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        keyboardDown = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createAccount" {
            let vc = segue.destinationViewController as! CreateAccountTableViewController
            vc.transitioningDelegate = transitionManager
        }
    }
}
