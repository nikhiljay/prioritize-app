//
//  SettingsTableViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 7/15/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    
    var transitionManager = TransitionManager()
    var tableArray = ["test1", "test2", "test3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.currentUser()
        
        if let name = currentUser["name"] as? String {
            nameTextField.text = name
        }
    }

    
    func load() {
        view.showLoading()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let currentUser = PFUser.currentUser()
        
        load()
        currentUser["name"] = nameTextField.text
        
        self.performSegueWithIdentifier("finishedSettings", sender: self)
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
