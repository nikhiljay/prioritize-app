//
//  ItemsViewModel.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 9/15/15.
//  Copyright © 2015 Prioritize. All rights reserved.
//

import Foundation

struct ItemsViewModel {

    private(set) var items: [String] = []
    
    init() {
        items = load()
    }
    
    mutating func append(item: String) {
        items.append(item)
        save(items)
    }
    
    mutating func removeItemAt(index: Int) {
        items.removeAtIndex(index)
        save(items)
    }
    
    mutating func removeAllItems() {
        items.removeAll()
        save(items)
    }
    
    mutating func addArray(array: [String]) {
        items = array
        save(items)
    }
    
    func save(items: [String]) {
        defaults?.setObject(items, forKey: itemsKey)
        print(defaults?.synchronize())
    }
    
    func load() -> [String] {
        return defaults?.objectForKey(itemsKey) as? [String] ?? []
    }
    
    private let itemsKey = "items"
    private let defaults = NSUserDefaults(suiteName: "group.com.prioritize.prioritizeapp")
    
}
