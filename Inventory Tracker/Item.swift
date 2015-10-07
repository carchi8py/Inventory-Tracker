//
//  Item.swift
//  InventoryTracker
//
//  Created by Paul Solt on 11/23/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
   
    // Properties
    var name: String
    var cost: Double
    var imageName: String
    
    var image: UIImage?
    
    let kNameKey = "name"
    let kCostKey = "cost"
    let kImageNameKey = "imageName"
    
    // initializers
    
    init(name: String, cost: Double, imageName: String) {
        self.name = name
        self.cost = cost
        self.imageName = imageName
        
        self.image = nil
        
        // required to init super class
        super.init()
    }
    
    override var description: String {
        return "\(name), $\(cost), image name: \(imageName)"
    }
    
    // NSCoder Protocol methods
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey(kNameKey) as! String
        self.cost = aDecoder.decodeDoubleForKey(kCostKey) as Double
        self.imageName = aDecoder.decodeObjectForKey(kImageNameKey) as! String
        
        self.image = nil
    
        super.init() // subclass of another super.init(coder)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: kNameKey)
        aCoder.encodeDouble(cost, forKey: kCostKey)
        aCoder.encodeObject(imageName, forKey: kImageNameKey)
        
        // don't encode images in archives, store a name to the image file on disk
    }
    
}
