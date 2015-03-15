//
//  AddItemViewController.swift
//  Prioritize
//
//  Created by Kevin Li on 2/7/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var currentUser = PFUser.currentUser()
//    var events = PFUser.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 2
        doneButton.layer.cornerRadius = 7
        
        self.nameTextField.delegate = self
        self.startTimeTextField.delegate = self
        self.endTimeTextField.delegate = self
        self.locationTextField.delegate = self
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
            var alert = UIAlertView(title:"Oops!", message:"You did not give the event a name!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
        } else if self.startTimeTextField.text == "" {
            var alert = UIAlertView(title:"Oops!", message:"You did not give the event a start time!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
        } else if self.endTimeTextField.text == "" {
            var alert = UIAlertView(title:"Oops!", message:"You did not give the event an end time!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
        } else {
            if self.locationTextField.text == "" {
                var alert = UIAlertView(title:"No address", message:"You did not give the event an address. The event will be added but there will be no map. Edit the event to add an address if needed.", delegate: self, cancelButtonTitle:"Got it!")
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
            
            self.navigationController?.popViewControllerAnimated(true)
            
            //PUSH NOTIFICATION!
            if let notification = currentUser["notifications"] as? Bool {
                if notification == true {
                    var data = [
                        "alert" : "The event: \(nameTextField.text) is starting right now.",
                        "badge" : "Increment",
                        "sounds" : ""
                    ]
                    let push = PFPush()
                    push.setChannel("Notifications")
                    push.setData(data)
                    push.sendPushInBackground()
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}