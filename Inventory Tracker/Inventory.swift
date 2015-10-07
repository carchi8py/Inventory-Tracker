//
//  Inventory.swift
//  Inventory Tracker
//
//  Created by Chris Archibald on 10/6/15.
//  Copyright © 2015 Chris Archibald. All rights reserved.
//

import UIKit

class Inventory: NSObject, NSCoding {
    
    //list of items
    var itemArray: [Item]
    
    // last viewed Item
    var lastViewedIndex: Int?
    
    let kItemArray = "itemArray"
    let KLastViewedIndex = "lastViewedIndex"
    
    override init() {
        itemArray = [Item]()
        lastViewedIndex = nil
        
        super.init()
    }
    
    override var description: String {
        return "items: \(itemArray), lastViewedIndex \(lastViewedIndex)"
    }
    
    required init(coder decoder: NSCoder) {
        itemArray = decoder.decodeObjectForKey(kItemArray) as! [Item]
        lastViewedIndex = decoder.decodeObjectForKey(KLastViewedIndex) as! Int?
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(itemArray, forKey: kItemArray)
        aCoder.encodeObject(lastViewedIndex, forKey: KLastViewedIndex)
    }
}
