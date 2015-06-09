//
//  AddItemViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/7/15.
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
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!], forState: UIControlState.Normal)

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
    
    func showLoad() {
        view.showLoading()
    }
    
    func hideLoad() {
        view.hideLoading()
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        showLoad()
        
        var nameText = nameTextField.text!
        var addressText = locationTextField.text!
        var startTimesText = startTimeTextField.text!
        var endTimesText = endTimeTextField.text!
        
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
        if self.nameTextField.text!.isEmpty == true {
            var alert = UIAlertView(title:"Oops!", message:"You did not give the event a name!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if self.startTimeTextField.text!.isEmpty == true {
            var alert = UIAlertView(title:"Oops!", message:"You did not give the event a start time!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if self.endTimeTextField.text!.isEmpty == true {
            var alert = UIAlertView(title:"Oops!", message:"You did not give the event an end time!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
}