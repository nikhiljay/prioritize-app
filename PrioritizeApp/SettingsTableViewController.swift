//
//  SettingsTableViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 7/15/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var emptyTableCell: UITableViewCell!
    @IBOutlet weak var notificationsTableCell: UITableViewCell!
    @IBOutlet weak var passwordTableCell: UITableViewCell!
    @IBOutlet weak var nameTableCell: UITableViewCell!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var addPictureButton: UIButton!
    var imagePicker = UIImagePickerController()
    var popover: UIPopoverController? = nil
    var finalImage: UIImage!
    
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
        
        bottomView.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height-(topView.frame.height+nameTableCell.frame.height+passwordTableCell.frame.height+notificationsTableCell.frame.height+emptyTableCell.frame.height))
        
        imagePicker.delegate = self
        if currentUser["profilePicture"] == nil {
            selectedImage.hidden = true
        } else {
            selectedImage.image = currentUser["profilePicture"] as? UIImage
            
            let userPicture = currentUser["profilePicture"] as! PFFile
            
            userPicture.getDataInBackgroundWithBlock({ (imageData: NSData!, error) -> Void in
                if (error == nil) {
                    let image = UIImage(data: imageData)
                    self.selectedImage.image = image
                    self.selectedImage.contentMode = .ScaleAspectFill
                }
            })
            
            finalImage = selectedImage.image
            selectedImage.hidden = false
        }
        self.selectedImage.layer.masksToBounds = true
        self.selectedImage.layer.cornerRadius = 5
    }
    
    func showLoad() {
        Loading.start()
    }
    
    func hideLoad() {
        Loading.stop()
    }
    
    @IBAction func AddImageButton(sender: AnyObject) {
        imagePicker.allowsEditing = true
        
        let alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { UIAlertAction in
                self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default){ UIAlertAction in
                self.opengallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { UIAlertAction in }
        // Add the actions
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            alert.addAction(cameraAction)
        }
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }

        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(imagePicker, animated: true, completion: nil)
        }
        else {
            opengallery()
        }
    }
    
    func opengallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
            
        else {
            popover = UIPopoverController(contentViewController: imagePicker)
            popover!.presentPopoverFromRect(view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage.contentMode = .ScaleAspectFill
            selectedImage.image = image
            selectedImage.hidden = false
            finalImage = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let currentUser = PFUser.currentUser()
        
        showLoad()
        currentUser["name"] = nameTextField.text
        
        if notificationSwitch.on == true {
            currentUser["notifications"] = true
        }
        else {
            currentUser["notifications"] = false
        }
        
        if self.finalImage != nil {
            let currentUser = PFUser.currentUser()
            let imageData = UIImageJPEGRepresentation(self.finalImage, 0.1)
            let imageFile: PFFile = PFFile(data: imageData)
            currentUser["profilePicture"] = imageFile
            SoundPlayer.playDone()
            dismissViewControllerAnimated(true, completion: nil)
            currentUser.saveInBackground()
            hideLoad()
        } else {
            dismissViewControllerAnimated(true, completion: nil)
            SoundPlayer.playDone()
            currentUser.saveInBackground()
            hideLoad()
        }
        
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
