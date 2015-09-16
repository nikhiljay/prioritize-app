//
//  InterfaceController.swift
//  watchapp Extension
//
//  Created by Nikhil D'Souza on 9/15/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var table: WKInterfaceTable!
    var viewModel = ItemsViewModel()
    
    private var session : WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        NSLog("%@ awakeWithContext", self)
        
        viewModel.load()
        print(viewModel.items)
        
        loadTableData()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session!.delegate = self
            session!.activateSession()
        }
        
        NSLog("%@ will activate", self)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    
    
    
    func loadTableData() {
        
        if let session = session where session.reachable {
            session.sendMessage(applicationData,
                replyHandler: { replyData in
                    // handle reply from iPhone app here
                    print(replyData)
                }, errorHandler: { error in
                    // catch any errors here
                    print(error)
            })
        } else {
            print("not connected to iPhone")
        }
        
        
    }
    
}
