//
//  SettingsViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/26/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    var transitionManager = TransitionManager()
    var tableArray = ["test1", "test2", "test3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.currentUser()
        
        if let name = currentUser["name"] as? String {
//            nameTextField.text = name
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textFieldTableCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = tableArray[indexPath.row]
        
        return cell
    }


    func load() {
        view.showLoading()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let currentUser = PFUser.currentUser()
        
        load()
//        currentUser["name"] = nameTextField.text
        
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
