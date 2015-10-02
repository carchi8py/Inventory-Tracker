//
//  Item.swift
//  Inventory Tracker
//
//  Created by Chris Archibald on 10/1/15.
//  Copyright (c) 2015 Chris Archibald. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
   
    // Properties
    var name: String
    var cost: Double
    var imageName: String
    
    var image: UIImage?
    
    // Initializers
    
    init(name: String, cost: Double, imageName: String) {
        self.name = name
        self.cost = cost
        self.imageName = imageName
        
        self.image = nil
        
        // Required to init super class
        super.init()
    }
    
    override var description: String {
        return "\(name), \(cost), image Name: \(imageName)"
    }
    
    let kNameKey = "name"
    let kCostKey = "cost"
    let kImageNameKey = "imageName"
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey(kNameKey) as! String
        self.cost = aDecoder.decodeDoubleForKey(kCostKey) as Double
        self.imageName = aDecoder.decodeObjectForKey(kImageNameKey) as! String
        
        self.image = nil
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: kNameKey)
        aCoder.encodeDouble(cost, forKey: kCostKey)
        aCoder.encodeObject(imageName, forKey: kImageNameKey)
    
    // Don't encode images in archives, storm a name to the image file on disk
    }
}
