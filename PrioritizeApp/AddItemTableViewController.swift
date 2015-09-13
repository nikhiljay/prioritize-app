//
//  AddItemTableViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 7/15/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import UIKit
import Parse

class AddItemTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var allDaySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allDay()
        allDaySwitch.addTarget(self, action: "allDay", forControlEvents:UIControlEvents.ValueChanged)

    }
    
    func allDay() {
        if allDaySwitch.on == true {
            startTimeTextField.text = "None"
            endTimeTextField.text = "None"
            startTimeTextField.hidden = true
            endTimeTextField.hidden = true
        } else {
            startTimeTextField.text = ""
            endTimeTextField.text = ""
            startTimeTextField.hidden = false
            endTimeTextField.hidden = false
        }
    }
    
    func showLoad() {
        Loading.start()
    }
    
    func hideLoad() {
        Loading.stop()
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        let currentUser = PFUser.currentUser()
        showLoad()
        
        let nameText = nameTextField.text!
        let addressText = locationTextField.text!
        let startTimesText = startTimeTextField.text!
        let endTimesText = endTimeTextField.text!
        
        var events:[String]
        var addresses: [String]
        var startTimes: [String]
        var endTimes: [String]
        
        if let userEvents = currentUser["events"] as? [String] {
            events = userEvents
        } else {
            events = []
        }
        
        if let userAddresses = currentUser["addresses"] as? [String] {
            addresses = userAddresses
        } else {
            addresses = []
        }
        
        if let userStartTimes = currentUser["startTimes"] as? [String] {
            startTimes = userStartTimes
        } else {
            startTimes = []
        }
        
        if let userEndTimes = currentUser["endTimes"] as? [String] {
            endTimes = userEndTimes
        } else {
            endTimes = []
        }
        
        //NIL DID NOT WORK SO I USED ""
        if self.nameTextField.text!.isEmpty == true {
            let alert = UIAlertView(title:"Oops!", message:"You did not give the event a name!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if self.startTimeTextField.text!.isEmpty == true {
            let alert = UIAlertView(title:"Oops!", message:"You did not give the event a start time!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if self.endTimeTextField.text!.isEmpty == true {
            let alert = UIAlertView(title:"Oops!", message:"You did not give the event an end time!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else {
            if self.locationTextField.text == "" {
                let alert = UIAlertView(title:"No address", message:"You did not give the event an address. The event will be added but there will be no map. Edit the event to add an address if needed.", delegate: self, cancelButtonTitle:"Got it!")
                alert.show()
            }
            events.append(nameText)
            currentUser["events"] = events
            
            addresses.append(addressText)
            currentUser["addresses"] = addresses
            
            startTimes.append(startTimesText)
            currentUser["startTimes"] = startTimes
            
            endTimes.append(endTimesText)
            currentUser["endTimes"] = endTimes
            
            currentUser.saveInBackground()
            
            self.dismissViewControllerAnimated(true, completion: nil)
            hideLoad()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
