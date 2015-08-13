//
//  CreateAccountTableViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 7/17/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import UIKit
import Parse

class CreateAccountTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    var imagePicker = UIImagePickerController()
    var finalImage: UIImage!
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        selectedImage.hidden = true
        self.selectedImage.layer.masksToBounds = true
        self.selectedImage.layer.cornerRadius = 5
    }
    
    func showLoad() {
        view.showLoading()
    }
    
    func hideLoad() {
        view.hideLoading()
    }

    @IBAction func AddImageButton(sender : AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
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

    @IBAction func doneButtonPressed(sender: AnyObject) {
        showLoad()
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        let email = emailTextField.text
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        if self.passwordTextField.text == "" {
            let alert = UIAlertView(title:"Oops!", message:"Password field is empty!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if self.usernameTextField.text == "" {
            hideLoad()
            let alert = UIAlertView(title:"Oops!", message:"Username field is empty!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if self.emailTextField.text == "" {
            hideLoad()
            let alert = UIAlertView(title:"Oops!", message:"Email field is empty!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if password!.characters.count < 5 {
            let alert = UIAlertView(title:"Oops!", message:"Too short password! Needs at least 5 characters.", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else {
            user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
                if error == nil {
                    if self.finalImage != nil {
                        let currentUser = PFUser.currentUser()
                        let imageData = UIImageJPEGRepresentation(self.finalImage, 0.1)
                        let imageFile: PFFile = PFFile(data: imageData)
                        currentUser["profilePicture"] = imageFile
                        self.performSegueWithIdentifier("accountCreated", sender: self)
                        currentUser.saveInBackground()
                    } else {
                        self.performSegueWithIdentifier("accountCreated", sender: self)
                    }
                } else {
                    let errorString = error!.userInfo["error"] as! String
                    let alert = UIAlertView(title:"Oops!", message: "\(errorString)!", delegate: self, cancelButtonTitle:"Got it!")
                    alert.show()
                    self.hideLoad()
                }
            }
        }
    }

}
