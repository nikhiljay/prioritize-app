//
//  InterfaceController.swift
//  Prioritize WatchKit 1 Extension
//
//  Created by Nikhil D'Souza on 9/15/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    var viewModel = ItemsViewModel()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        NSLog("%@ awakeWithContext", self)
        viewModel.load()
        loadTableData()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    
    func loadTableData() {
        if table.numberOfRows != viewModel.items.count {
            table.setNumberOfRows(viewModel.items.count, withRowType: "tableCell")
        }
        
        for (index, item) in viewModel.items.enumerate() {
            if let row = table.rowControllerAtIndex(index) as? ItemRowController {
                row.label.setText(item)
            }
        }
    }
    
}
