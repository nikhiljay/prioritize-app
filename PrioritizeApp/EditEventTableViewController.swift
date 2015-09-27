//
//  EditEventTableViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 7/15/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import UIKit
import Parse
import Spring

class EditEventTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var allDaySwitch: UISwitch!
    
    var eventIndex: Int?
    var addressIndex: Int?
    var startTimeIndex: Int?
    var endTimeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.currentUser()
        
        //SET TEXT FIELD TEXT AS CREATED TEXT
        
        //EVENT TITLE
        var eventTitle = "No Event Title"
        
        if let events = currentUser["events"] as? [String] {
            if eventIndex != nil {
                eventTitle = events[eventIndex!]
            }
        }
        nameTextField.text = eventTitle
        
        //ADDRESS TITLE
        var addressTitle = "No Address"
        
        if let addresses = currentUser["addresses"] as? [String] {
            if addressIndex != nil {
                addressTitle = addresses[addressIndex!]
            }
        }
        locationTextField.text = addressTitle
        
        allDay()
        
        //END TIME TITLE
        var endTimeTitle = "No End Time"
        let endTimes = currentUser["endTimes"] as? [String]
        if let endTimes = currentUser["endTimes"] as? [String] {
            if endTimeIndex != nil {
                endTimeTitle = endTimes[endTimeIndex!]
            }
        }
        endTimeTextField.text = endTimeTitle
        
        //START TIME TITLE
        var startTimeTitle = "No Start Time"
        let startTimes = currentUser["startTimes"] as? [String]
        if let startTimes = currentUser["startTimes"] as? [String] {
            if startTimeIndex != nil {
                startTimeTitle = startTimes[startTimeIndex!]
            }
        }
        startTimeTextField.text = startTimeTitle
        
        if startTimes?[startTimeIndex!] == "None" && endTimes?[endTimeIndex!] == "None" {
            allDaySwitch.on = true
            startTimeTextField.hidden = true
            endTimeTextField.hidden = true
        }
        
        allDaySwitch.addTarget(self, action: "allDay", forControlEvents:UIControlEvents.ValueChanged)
        
        var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapReceived")
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func tapReceived() {
        view.endEditing(true)
    }
    
    func allDay() {
        let currentUser = PFUser.currentUser()
        var startTimeTitle = "No Start Time"
        var endTimeTitle = "No End Time"
        
        if allDaySwitch.on == true {
            startTimeTextField.hidden = true
            endTimeTextField.hidden = true
        } else {
                
            if let startTimes = currentUser["startTimes"] as? [String] {
                if startTimeIndex != nil {
                    startTimeTitle = startTimes[startTimeIndex!]
                }
            }
            
            if let endTimes = currentUser["endTimes"] as? [String] {
                if endTimeIndex != nil {
                    endTimeTitle = endTimes[endTimeIndex!]
                }
            }
            
            let endTimes = currentUser["endTimes"] as? [String]
            let startTimes = currentUser["startTimes"] as? [String]
            
            if startTimes?[startTimeIndex!] == "None" && endTimes?[endTimeIndex!] == "None" {
                startTimeTitle = ""
                endTimeTitle = ""
            }
            
            startTimeTextField.text = startTimeTitle
            endTimeTextField.text = endTimeTitle
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
        var startTimesText = startTimeTextField.text!
        var endTimesText = endTimeTextField.text!
        
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
        if self.nameTextField.text == "" {
            let alert = UIAlertView(title:"Oops", message:"You did not give the event a name!", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            hideLoad()
        } else if self.startTimeTextField.text == "" {
            let alert = UIAlertView(title:"Oops", message:"You did not give the event a start time!", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            hideLoad()
        } else if self.endTimeTextField.text == "" {
            let alert = UIAlertView(title:"Oops", message:"You did not give the event an end time!", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            hideLoad()
        } else {
            if allDaySwitch.on == true {
                startTimesText = "None"
                endTimesText = "None"
                
                events[eventIndex!] = nameText
                currentUser["events"] = events
                
                addresses[addressIndex!] = addressText
                currentUser["addresses"] = addresses
                
                startTimes[startTimeIndex!] = startTimesText
                currentUser["startTimes"] = startTimes
                
                endTimes[endTimeIndex!] = endTimesText
                currentUser["endTimes"] = endTimes
            } else {
                events[eventIndex!] = nameText
                currentUser["events"] = events
            
                addresses[addressIndex!] = addressText
                currentUser["addresses"] = addresses
            
                startTimes[startTimeIndex!] = startTimesText
                currentUser["startTimes"] = startTimes
            
                endTimes[endTimeIndex!] = endTimesText
                currentUser["endTimes"] = endTimes
            }

            self.dismissViewControllerAnimated(true, completion: nil)
            hideLoad()
            currentUser.saveInBackground()
        }
    }

}
