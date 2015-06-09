//
//  IntroViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 4/15/15.
//  Copyright (c) 2015 Prioritize. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, DragDropBehaviorDelegate {
    @IBOutlet weak var textLabel: SpringLabel!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.textLabel.animation = "flash"
        self.textLabel.animate()
        self.textLabel.text = "Drag down to dismiss."
    }
    
    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.mainScreen().bounds.size.height == 480 {
            textLabel.hidden = true
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
