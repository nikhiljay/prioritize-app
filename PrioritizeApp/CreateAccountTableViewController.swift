//
//  CreateAccountTableViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 7/17/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import UIKit
import Parse

class CreateAccountTableViewController: UITableViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    var imagePicker = UIImagePickerController()
    
    func showLoad() {
        view.showLoading()
    }
    
    func hideLoad() {
        view.hideLoading()
    }

    @IBAction func AddImageButton(sender : AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.contentMode = .ScaleAspectFit
            selectedImage.image = pickedImage
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        
        if self.passwordTextField.text == nil {
            let alert = UIAlertView(title:"Oops!", message:"Password field is empty!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if self.usernameTextField.text == nil {
            hideLoad()
            let alert = UIAlertView(title:"Oops!", message:"Username field is empty!", delegate: self, cancelButtonTitle:"Got it!")
            alert.show()
            hideLoad()
        } else if self.emailTextField.text == nil {
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
                    self.performSegueWithIdentifier("accountCreated", sender: self)
                    self.performSegueWithIdentifier("loggedIn", sender: LoginViewController())
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
