//
//  TableViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/7/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuView: DesignableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var maskView: SpringButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dayLabel: SpringLabel!
    @IBOutlet weak var dateLabel: SpringLabel!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var events: [String]?
    var addresses: [String]?
    var startTimes: [String]?
    var endTimes: [String]?
    
    var refreshControl = UIRefreshControl()
    var transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("loginNav") as! UINavigationController
            
            self.presentViewController(vc, animated: true, completion: nil)
        } else {

        currentUser.refresh()
        
        if !LocalStore.isIntroVisited() {
            performSegueWithIdentifier("IntroSegue", sender: self)
            LocalStore.setIntroAsVisited()
        }

        menuView.hidden = true
        maskView.hidden = true
    
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //REFRESHING!
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.whiteColor()
        self.tableView.addSubview(refreshControl)
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        //DATE
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy MMMM dd"
        
        let date = NSDate()
        
        dateFormatter.dateFormat = "d"
        let day = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.stringFromDate(date)
        
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.stringFromDate(date)
        
        dayLabel.text = dayOfWeekString
        dateLabel.text = "\(month) \(day), \(year)"
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("loginNav") as! UINavigationController
            
            self.presentViewController(vc, animated: true, completion: nil)
        } else {
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
            let time = dateFormatter.stringFromDate(date)
//            print(time)
            
            if let name = currentUser["name"] as? String {
                if name == "" {
                    navigationItem.title = "Your Day"
                } else {
                    navigationItem.title = "\(name)'s Day"
                }
            }
        }
    }

    func refresh(sender: AnyObject) {
        let currentUser = PFUser.currentUser()

        currentUser.refresh()
        if let refreshedEvents = currentUser["events"] as? [String] {
            events = refreshedEvents
        }
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("loginNav") as! UINavigationController
            
            self.presentViewController(vc, animated: true, completion: nil)
        } else {
            events = currentUser["events"] as? [String]
            refreshArray()
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let currentUser = PFUser.currentUser()
        
        events = currentUser["events"] as? [String]
        if editingStyle == UITableViewCellEditingStyle.Delete {
            events?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            currentUser["events"] = events
        }
        
        addresses = currentUser["addresses"] as? [String]
        if editingStyle == UITableViewCellEditingStyle.Delete {
            addresses?.removeAtIndex(indexPath.row)
            currentUser["addresses"] = addresses
        }
        
        startTimes = currentUser["startTimes"] as? [String]
        if editingStyle == UITableViewCellEditingStyle.Delete {
            startTimes?.removeAtIndex(indexPath.row)
            currentUser["startTimes"] = startTimes
        }
        
        endTimes = currentUser["endTimes"] as? [String]
        if editingStyle == UITableViewCellEditingStyle.Delete {
            endTimes?.removeAtIndex(indexPath.row)
            currentUser["endTimes"] = endTimes
        }
        
        currentUser.saveInBackground()
    }

    func refreshArray() {
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentUser = PFUser.currentUser()
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        startTimes = currentUser["startTimes"] as? [String]
        endTimes = currentUser["endTimes"] as? [String]
        let startTime = startTimes?[indexPath.row]
        let endTime = endTimes?[indexPath.row]
        
        var allDayStart: Bool!
        var allDayEnd: Bool!
        
        if endTime == "None" {
            allDayEnd = true
        } else {
            allDayEnd = false
        }
        
        if startTime == "None" {
            allDayStart = true
        } else {
            allDayStart = false
        }
        
        if let events = events {
            cell.textLabel?.text = events[indexPath.row]
            
            if allDayEnd == true && allDayStart == true {
                cell.detailTextLabel?.text = "All Day"
            } else {
                cell.detailTextLabel?.text = "\(startTime!) to \(endTime!)"
            }
        }
        
        return cell
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        if maskView.hidden == true {
            showMenu()
            showMask()
        } else {
            hideMenu()
        }
    }
    
    @IBAction func maskViewPressed(sender: AnyObject) {
        hideMenu()
    }
    
    func showMenu() {
        menuView.hidden = false
        menuView.animation = "squeezeDown"
        menuView.animate()
    }
    
    func showMask() {
        maskView.hidden = false
        maskView.animation = "fadeIn"
        maskView.animate()
    }
    
    func hideMenu() {
        menuView.animation = "fall"
        menuView.animate()
        maskView.hidden = true
    }

    @IBAction func logoutPressed(sender: AnyObject) {
        PFUser.logOut()
        presentLoginViewController()
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        hideMenu()
        tableView.setEditing(true, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "stopEditing")
    }
    
    func stopEditing() {
        let currentUser = PFUser.currentUser()
        
        tableView.setEditing(false, animated: true)
        tableView.dataSource?.numberOfSectionsInTableView!(tableView)
        navigationBar.rightBarButtonItem = nil
        currentUser.saveInBackground()
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let currentUser = PFUser.currentUser()
        currentUser.saveInBackground()
    }
    
    func presentLoginViewController() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("loginNav") as! UINavigationController
        
        self.presentViewController(vc, animated: false, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let currentUser = PFUser.currentUser()
        
        events = currentUser["events"] as? [String]
        addresses = currentUser["addresses"] as? [String]
        startTimes = currentUser["startTimes"] as? [String]
        endTimes = currentUser["endTimes"] as? [String]
        
        if segue.identifier == "ShowDetailSegue" {
            let vc = segue.destinationViewController as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.eventIndex = indexPath.row
                vc.addressIndex = indexPath.row
                vc.startTimeIndex = indexPath.row
                vc.endTimeIndex = indexPath.row
            }
            vc.transitioningDelegate = transitionManager
        } else if segue.identifier == "ShowWebSegue" {
            let vc = segue.destinationViewController as! AboutUsWebViewController
            vc.transitioningDelegate = transitionManager
        } else if segue.identifier == "ShowSettingsSegue" {
            let vc = segue.destinationViewController as! SettingsTableViewController
            vc.transitioningDelegate = transitionManager
        } else if segue.identifier == "AddItemSegue" {
            let vc = segue.destinationViewController as! AddItemTableViewController
            vc.transitioningDelegate = transitionManager
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
