//
//  Inventory.swift
//  Inventory Tracker
//
//  Created by Chris Archibald on 10/6/15.
//  Copyright © 2015 Chris Archibald. All rights reserved.
//

import UIKit

class Inventory: NSObject {
    
    //list of items
    var itemArray: [Item]
    
    // last viewed Item
    var lastViewedIndex: Int?
    
    override init() {
        itemArray = [Item]()
        lastViewedIndex = nil
        
        super.init()
    }
    
    override var description: String {
        return "items: \(itemArray), lastViewedIndex \(lastViewedIndex)"
    }
    
}
