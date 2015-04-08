//
//  LoginViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/7/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet weak var mainView: DesignableView!
    @IBOutlet weak var emailImageView: SpringImageView!
    @IBOutlet weak var passwordImageView: SpringImageView!
    var originalCenter: CGPoint!
    
    var keyboardDown: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardDown = true
        
        animator = UIDynamicAnimator(referenceView: view)
        originalCenter = view.center
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoad() {
        view.showLoading()
    }
    
    func hideLoad() {
        view.hideLoading()
    }
    
    @IBAction func signUpPressed(sender: AnyObject) {
        showLoad()
        
        var username = usernameTextField.text
        var password = passwordTextField.text
        
        var user = PFUser()
        user.username = username
        user.password = password
        
        if self.passwordTextField.text == nil {
            shakeMainView()
            var alert = UIAlertView(title:"Oops!", message:"Password field is empty!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if self.usernameTextField.text == nil {
            shakeMainView()
            hideLoad()
            var alert = UIAlertView(title:"Oops!", message:"Username field is empty!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if countElements(password) < 5 {
            shakeMainView()
            var alert = UIAlertView(title:"Oops!", message:"Too short password! Needs at least 5 characters.", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else {
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    self.performSegueWithIdentifier("loggedIn", sender: self)
                } else {
                    let errorString = error.userInfo!["error"] as NSString
                    var alert = UIAlertView(title:"Oops!", message: "\(errorString)!", delegate: self, cancelButtonTitle:"Got it!")
                    alert.show()
                    self.hideLoad()
                }
            }
            
//            var installation: PFInstallation = PFInstallation.currentInstallation()
//            installation.addUniqueObject(["Notifications"], forKey: "channels")
//            installation["user"] = PFUser.currentUser()
//            installation.saveInBackground()
        }
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        showLoad()
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text, block: { (user,error) in
            if error != nil {
                self.shakeMainView()
                self.hideLoad()
            } else {
                var installation: PFInstallation = PFInstallation.currentInstallation()
                installation.addUniqueObject(["Notifications"], forKey: "channels")
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
                
                self.performSegueWithIdentifier("loggedIn", sender: self)
                self.passwordTextField.text = nil
                self.usernameTextField.text = nil
                
                self.mainView.animation = "zoomOut"
                self.mainView.animate()
            }
        })
    }
    
    func shakeMainView() {
        mainView.animation = "shake"
        mainView.animate()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        keyboardDown = false
        if textField == usernameTextField {
            emailImageView.image = UIImage(named: "icon-mail-active")
            emailImageView.animate()
        }
        else {
            emailImageView.image = UIImage(named: "icon-mail")
        }
        if textField == passwordTextField {
            passwordImageView.image = UIImage(named: "icon-password-active")
            passwordImageView.animate()
        }
        else {
            passwordImageView.image = UIImage(named: "icon-password")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        usernameTextField.resignFirstResponder()
        emailImageView.image = UIImage(named: "icon-mail")
        passwordTextField.resignFirstResponder()
        passwordImageView.image = UIImage(named: "icon-password")
        keyboardDown = true
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        emailImageView.image = UIImage(named: "icon-mail")
        passwordImageView.image = UIImage(named: "icon-password")
        view.endEditing(true)
        keyboardDown = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        emailImageView.image = UIImage(named: "icon-mail")
        passwordImageView.image = UIImage(named: "icon-password")
        keyboardDown = true
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        keyboardDown = true
    }
    
    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var snapBehavior : UISnapBehavior!
    
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    @IBAction func handleGesture(sender: AnyObject) {
        if keyboardDown == true {
            let myView = mainView
            let location = sender.locationInView(view)
            let boxLocation = sender.locationInView(mainView)
            
            if sender.state == UIGestureRecognizerState.Began {
                animator.removeBehavior(snapBehavior)
                
                let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(myView.bounds), boxLocation.y - CGRectGetMidY(myView.bounds));
                attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
                attachmentBehavior.frequency = 0
                
                animator.addBehavior(attachmentBehavior)
            }
            else if sender.state == UIGestureRecognizerState.Changed {
                attachmentBehavior.anchorPoint = location
            }
            else if sender.state == UIGestureRecognizerState.Ended {
                animator.removeBehavior(attachmentBehavior)
                
                snapBehavior = UISnapBehavior(item: myView, snapToPoint: view.center)
                animator.addBehavior(snapBehavior)
            }
        }
    }
}
