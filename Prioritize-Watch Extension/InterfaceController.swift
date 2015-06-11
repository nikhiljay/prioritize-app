//
//  InterfaceController.swift
//  Prioritize-Watch Extension
//
//  Created by Nikhil D'Souza on 6/10/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var tableView: WKInterfaceTable!
    var testArray = ["test1","test2","test3"]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        loadTableData()
    }
    
    func loadTableData() {
        
        tableView.setNumberOfRows(testArray.count, withRowType: "TableRow")
        var index: Int = 0
        
        for text in testArray {
            let row = tableView.rowControllerAtIndex(index) as! TableRow
            row.eventLabel.setText(text)
            index++
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
