//
//  EditEventViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/19/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit

class EditEventViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var eventIndex: Int?
    var addressIndex: Int?
    var startTimeIndex: Int?
    var endTimeIndex: Int?
    
    var currentUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 2
        doneButton.layer.cornerRadius = 7
        
        self.nameTextField.delegate = self
        self.startTimeTextField.delegate = self
        self.endTimeTextField.delegate = self
        self.locationTextField.delegate = self
        
        //SET TEXT FIELD TEXT AS CREATED TEXT
        
        //EVENT TITLE
        let event = currentUser["events"]![eventIndex!] as String
        var eventTitle = "No Event Title"
        
        if let events = currentUser["events"] as? [String] {
            if eventIndex != nil {
                eventTitle = events[eventIndex!]
            }
        }
        nameTextField.text = eventTitle
        
        //ADDRESS TITLE
        let address = currentUser["addresses"]![addressIndex!] as String
        var addressTitle = "No Address"
        
        if let addresses = currentUser["addresses"] as? [String] {
            if addressIndex != nil {
                addressTitle = addresses[addressIndex!]
            }
        }
        locationTextField.text = addressTitle
        
        //END TIME TITLE
        let endTime = currentUser["endTimes"]![endTimeIndex!] as String
        var endTimeTitle = "No End Time"
        
        if let endTimes = currentUser["endTimes"] as? [String] {
            if endTimeIndex != nil {
                endTimeTitle = endTimes[endTimeIndex!]
            }
        }
        endTimeTextField.text = endTimeTitle
        
        //START TIME TITLE
        let startTime = currentUser["startTimes"]![startTimeIndex!] as String
        var startTimeTitle = "No Start Time"
        
        if let startTimes = currentUser["startTimes"] as? [String] {
            if startTimeIndex != nil {
                startTimeTitle = startTimes[startTimeIndex!]
            }
        }
        startTimeTextField.text = startTimeTitle
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        var nameText = nameTextField.text as String
        var addressText = locationTextField.text as String
        var startTimesText = startTimeTextField.text as String
        var endTimesText = endTimeTextField.text as String
        
        var currentUser = PFUser.currentUser()
        
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
            var alert = UIAlertView(title:"Oops", message:"You did not give the event a name!", delegate: self, cancelButtonTitle:"Ok")
            alert.show()
        } else if self.startTimeTextField.text == "" {
            var alert = UIAlertView(title:"Oops", message:"You did not give the event a start time!", delegate: self, cancelButtonTitle:"Ok")
            alert.show()
        } else if self.endTimeTextField.text == "" {
            var alert = UIAlertView(title:"Oops", message:"You did not give the event an end time!", delegate: self, cancelButtonTitle:"Ok")
            alert.show()
        } else {
            events[eventIndex!] = nameText
            currentUser["events"] = events
            
            addresses[addressIndex!] = addressText
            currentUser["addresses"] = addresses
            
            startTimes[startTimeIndex!] = startTimesText
            currentUser["startTimes"] = startTimes
            
            endTimes[endTimeIndex!] = endTimesText
            currentUser["endTimes"] = endTimes
            
            self.performSegueWithIdentifier("finishedEditing", sender: self)
            
            currentUser.saveInBackground()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        return false;
    }
}
