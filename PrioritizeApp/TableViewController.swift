//
//  TableViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/7/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuView: DesignableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var maskView: SpringButton!
    @IBOutlet weak var newEventBubbleImage: SpringImageView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    var currentUser = PFUser.currentUser()
    var events: [String]?
    var addresses: [String]?
    var startTimes: [String]?
    var endTimes: [String]?
    
    var refreshControl = UIRefreshControl()
    
    var transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser.refresh()

        //insertBlurView(maskView, UIBlurEffectStyle.Dark)
        menuView.hidden = true
        maskView.hidden = true
    
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if let name = currentUser["name"] as? String {
            if name == "" {
                navigationItem.title = "Your Day"
            } else {
                navigationItem.title = "\(name)'s Day"
            }
        }
        
        //REFRESHING!
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.whiteColor()
        self.tableView.addSubview(refreshControl)

        //NEW EVENT BUBBLE IMAGE!
        newEventBubbleImage.hidden = true
    }
    
    func refresh(sender: AnyObject) {
        currentUser.refresh()
        if let refreshedEvents = currentUser["events"] as? [String] {
            events = refreshedEvents
        }
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        events = currentUser["events"] as? [String]
        refreshArray()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        if let events = events {
            cell.textLabel?.text = events[indexPath.row]
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
    
    func presentLoginViewController() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("loginNav") as UINavigationController
        
        self.presentViewController(vc, animated: false, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        events = currentUser["events"] as? [String]
        addresses = currentUser["addresses"] as? [String]
        startTimes = currentUser["startTimes"] as? [String]
        endTimes = currentUser["endTimes"] as? [String]
        
        if segue.identifier == "ShowDetailSegue" {
            let vc = segue.destinationViewController as DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow() {
                vc.eventIndex = indexPath.row
                vc.addressIndex = indexPath.row
                vc.startTimeIndex = indexPath.row
                vc.endTimeIndex = indexPath.row
            }
            vc.transitioningDelegate = transitionManager
        } else if segue.identifier == "ShowWebSegue" {
            let vc = segue.destinationViewController as AboutUsWebViewController
            vc.transitioningDelegate = transitionManager
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
