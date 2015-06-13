//
//  TodayViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/7/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd"
        
        let date = NSDate()
        
        dateFormatter.dateFormat = "d"
        let day = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.stringFromDate(date)
        
        dayLabel.text = "\(day)"
        monthLabel.text = "\(month)" + "."
        yearLabel.text = "\(year)"
        
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
