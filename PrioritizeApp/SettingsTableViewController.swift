//
//  SettingsTableViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 7/15/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController, UIAlertViewDelegate {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    
    var transitionManager = TransitionManager()
    var tableArray = ["test1", "test2", "test3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.currentUser()
        
        if let name = currentUser["name"] as? String {
            nameTextField.text = name
        }
        
        if let notifications = currentUser["notifications"] as? Bool {
            notificationSwitch.on = notifications
        }
    }

    
    func load() {
        view.showLoading()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let currentUser = PFUser.currentUser()
        
        load()
        currentUser["name"] = nameTextField.text
        
        if notificationSwitch.on == true {
            currentUser["notifications"] = true
        }
        else {
            currentUser["notifications"] = false
        }
        dismissViewControllerAnimated(true, completion: nil)
        currentUser.saveInBackground()
    }
    
    @IBAction func passwordButtonPressed(sender: AnyObject) {
        showOldPassword()
    }
    
    func showOldPassword() {
        let oldPasswordAlert = UIAlertView(title:"Change Password", message:"Enter your old password.", delegate: self, cancelButtonTitle:"Done")
        oldPasswordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        oldPasswordAlert.show()
        
        let oldTextField = oldPasswordAlert.textFieldAtIndex(0)
        oldTextField!.placeholder = "Old Password"
        oldTextField!.keyboardType = UIKeyboardType.Alphabet
    }
    
    func showNewPassword() {
        let newPasswordAlert = UIAlertView(title:"Change Password", message:"Enter your new password.", delegate: self, cancelButtonTitle:"Done")
        newPasswordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        newPasswordAlert.show()
        
        let newTextField = newPasswordAlert.textFieldAtIndex(0)
        newTextField!.placeholder = "New Password"
        newTextField!.keyboardType = UIKeyboardType.Alphabet
    }
    
    func showIncorrectPassword() {
        let incorrectPasswordAlert = UIAlertView(title:"Incorrect Password", message:"Either the password that you have entered was incorrect, or there is no internet connection. Please try again.", delegate: self, cancelButtonTitle:"Got it!")
        incorrectPasswordAlert.alertViewStyle = UIAlertViewStyle.Default
        incorrectPasswordAlert.show()
    }
    
    func showInvalidPassword() {
        let incorrectPasswordAlert = UIAlertView(title:"Invalid Password", message:"Too short password! Needs at least 5 characters.", delegate: self, cancelButtonTitle:"Got it!")
        incorrectPasswordAlert.alertViewStyle = UIAlertViewStyle.Default
        incorrectPasswordAlert.show()
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        let currentUser = PFUser.currentUser()
        
        if alertView.title == "Incorrect Password" {}
        else if alertView.textFieldAtIndex(0)?.placeholder == "Old Password" {
            PFUser.logInWithUsernameInBackground(currentUser.username, password: alertView.textFieldAtIndex(0)?.text!, block: { (user,error) in
                if error == nil {
                    self.showNewPassword()
                } else if alertView.textFieldAtIndex(0)?.text! == "" {}
                else {
                    self.showIncorrectPassword()
                }
            })
        } else {
            currentUser.password = alertView.textFieldAtIndex(0)?.text!
        }
        
        currentUser.saveInBackground()
    }

    //FOR DELETING ALL EVENTS!!!
    @IBAction func deleteAllButtonPressed(sender: AnyObject) {
        let currentUser = PFUser.currentUser()
        let alert = UIAlertController(title: "Are you sure?", message: "This will delete all your events permanently from your account.", preferredStyle: UIAlertControllerStyle.Alert)
        let actionLeft = UIAlertAction(title: "No", style: .Cancel) { action in }
        let actionRight = UIAlertAction(title: "Yes", style: .Default) { action in
            currentUser["events"] = []
            currentUser["addresses"] = []
            currentUser["startTimes"] = []
            currentUser["endTimes"] = []
            currentUser.saveInBackground()
        }
        alert.addAction(actionLeft)
        alert.addAction(actionRight)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //FOR DELETING ACCOUNT!!!
    @IBAction func deleteAccountButtonPressed(sender: AnyObject) {
        let currentUser = PFUser.currentUser()
        let alert = UIAlertController(title: "Are you sure?", message: "This will permanently delete your account.", preferredStyle: UIAlertControllerStyle.Alert)
        let actionLeft = UIAlertAction(title: "No", style: .Cancel) { action in }
        let actionRight = UIAlertAction(title: "Yes", style: .Destructive) { action in
            currentUser.deleteInBackground()
            self.performSegueWithIdentifier("accountDeleted", sender: self)
        }
        alert.addAction(actionLeft)
        alert.addAction(actionRight)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    


}
