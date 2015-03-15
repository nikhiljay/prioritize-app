//
//  MakeYourDayViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/8/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit

class MakeYourDayViewController: UIViewController {

    @IBOutlet weak var makeYourDayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        makeYourDayButton.layer.borderColor = UIColor.whiteColor().CGColor
        makeYourDayButton.layer.borderWidth = 2
        makeYourDayButton.layer.cornerRadius = 7
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
