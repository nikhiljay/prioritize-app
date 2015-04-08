//
//  SettingsViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/26/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    var currentUser = PFUser.currentUser()
    
    var transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 2
        doneButton.layer.cornerRadius = 7
        
        deleteAllButton.layer.borderColor = UIColor(red: 0.68, green: 0.06, blue: 0.04, alpha: 1.0).CGColor
        deleteAllButton.layer.borderWidth = 1
        deleteAllButton.layer.cornerRadius = 7
        
        deleteAccountButton.layer.borderColor = UIColor(red: 0.68, green: 0.06, blue: 0.04, alpha: 1.0).CGColor
        deleteAccountButton.layer.borderWidth = 1
        deleteAccountButton.layer.cornerRadius = 7
        
        if let name = currentUser["name"] as? String {
            nameTextField.text = name
        }
        
        if let notification = currentUser["notifications"] as? Bool {
            notificationSwitch.on = notification
        }
        notificationSettingResult()
        notificationSwitch.addTarget(self, action: "notificationSettingResult", forControlEvents:UIControlEvents.ValueChanged)
        // Do any additional setup after loading the view.
    }
    
    func notificationSettingResult() {
        if notificationSwitch.on == true {
            currentUser["notifications"] = true
            println(currentUser["notifications"])
        }
        else {
            currentUser["notifications"] = false
            println(currentUser["notifications"])
        }
    }

    func load() {
        view.showLoading()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        load()
        
        currentUser["name"] = nameTextField.text
        
        self.performSegueWithIdentifier("finishedSettings", sender: self)
        
        currentUser.saveInBackground()
    }
    
    @IBAction func deleteAllButtonPressed(sender: AnyObject) {
        var alert = UIAlertController(title: "Are you sure?", message: "This will delete all your events permanently from your account.", preferredStyle: UIAlertControllerStyle.Alert)
        let actionLeft = UIAlertAction(title: "No", style: .Cancel) { action in }
        let actionRight = UIAlertAction(title: "Yes", style: .Default) { action in
            self.currentUser["events"] = []
            self.currentUser["addresses"] = []
            self.currentUser["startTimes"] = []
            self.currentUser["endTimes"] = []
            self.currentUser.saveInBackground()
        }
        alert.addAction(actionLeft)
        alert.addAction(actionRight)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccountButtonPressed(sender: AnyObject) {
        var alert = UIAlertController(title: "Are you sure?", message: "This will permanently delete your account.", preferredStyle: UIAlertControllerStyle.Alert)
        let actionLeft = UIAlertAction(title: "No", style: .Cancel) { action in }
        let actionRight = UIAlertAction(title: "Yes", style: .Destructive) { action in
            self.currentUser.deleteInBackground()
            self.performSegueWithIdentifier("accountDeleted", sender: self)
        }
        alert.addAction(actionLeft)
        alert.addAction(actionRight)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
