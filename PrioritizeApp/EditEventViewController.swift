//
//  EditEventViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/19/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit
import Parse

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
//        let event = (currentUser["events"] as! [String])[eventIndex!]
        var eventTitle = "No Event Title"
        
        if let events = currentUser["events"] as? [String] {
            if eventIndex != nil {
                eventTitle = events[eventIndex!]
            }
        }
        nameTextField.text = eventTitle
        
        //ADDRESS TITLE
//        let address = (currentUser["addresses"]as! [String])[addressIndex!]
        var addressTitle = "No Address"
        
        if let addresses = currentUser["addresses"] as? [String] {
            if addressIndex != nil {
                addressTitle = addresses[addressIndex!]
            }
        }
        locationTextField.text = addressTitle
        
        //END TIME TITLE
//        let endTime = (currentUser["endTimes"]as! [String])[endTimeIndex!]
        var endTimeTitle = "No End Time"
        
        if let endTimes = currentUser["endTimes"] as? [String] {
            if endTimeIndex != nil {
                endTimeTitle = endTimes[endTimeIndex!]
            }
        }
        endTimeTextField.text = endTimeTitle
        
        //START TIME TITLE
//        let startTime = (currentUser["startTimes"]as! [String])[startTimeIndex!]
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
    
    func showLoad() {
        view.showLoading()
    }
    
    func hideLoad() {
        view.hideLoading()
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        showLoad()
        
        let nameText = nameTextField.text!
        let addressText = locationTextField.text!
        let startTimesText = startTimeTextField.text!
        let endTimesText = endTimeTextField.text!
        
        let currentUser = PFUser.currentUser()
        
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
            let alert = UIAlertView(title:"Oops", message:"You did not give the event a name!", delegate: self, cancelButtonTitle:"Ok")
            alert.show()
            hideLoad()
        } else if self.startTimeTextField.text == "" {
            let alert = UIAlertView(title:"Oops", message:"You did not give the event a start time!", delegate: self, cancelButtonTitle:"Ok")
            alert.show()
            hideLoad()
        } else if self.endTimeTextField.text == "" {
            let alert = UIAlertView(title:"Oops", message:"You did not give the event an end time!", delegate: self, cancelButtonTitle:"Ok")
            alert.show()
            hideLoad()
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
}
