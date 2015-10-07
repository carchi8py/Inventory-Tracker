//
//  ViewController.swift
//  InventoryTracker
//
//  Created by Paul Solt on 10/28/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

import UIKit

func documentsDirectory() -> String {
    
    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
    return documentsFolderPath
}

func fileInDocumentsDirectory(filename: String) -> String {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    let fileURL = documentsURL.URLByAppendingPathComponent(filename)
    return fileURL.path!
}

// Conform to delegate protocol for ImagePicker
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    
    var inventory: Inventory!
    var inventoryPath = fileInDocumentsDirectory("inventory.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a tap gesture to the imageview
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        imageView.addGestureRecognizer(tapGesture)
    
        // Need to enable for interaction to make gestures work on imageview
        imageView.userInteractionEnabled = true
        
        // Make the image fit aspect ratio
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        // Load the inventory
        loadInventory()
    }
    
    // Load and Save Inventory
    
    func loadInventory() {
        // Try to load inventory
        if let inventory = loadInventory(fromPath: inventoryPath) {
            self.inventory = inventory
            print("Inventory loaded: \(self.inventory)")
        } else {
            // Initialize
            self.inventory = Inventory()
            print("Inventory created")
        }
    }
    
    func loadInventory(fromPath path: String) -> Inventory? {
        var result: Inventory? = nil
        result = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! Inventory?
        return result
    }
    
    func saveInventory() {
        var success = false
        
        success = saveInventory(inventory, path:inventoryPath)
        if success {
            print("Inventory saved successfully to path: \(inventoryPath)")
        } else {
            print("Inventory failed to save to path: \(inventoryPath)")
        }
    }
    
    func saveInventory(inventory: Inventory, path: String) -> Bool {
        var success = false
        
        success = NSKeyedArchiver.archiveRootObject(inventory, toFile: path)
        
        // save images
        
        if success {
            for item in inventory.itemArray {
                if let image = item.image {
                    
                    let imagePath = fileInDocumentsDirectory(item.imageName)
                    
                    let result = saveImage(image, path: imagePath)
                    
                    print("Save item image: \(result) \(imagePath)")
                    
                }
            }
            
        }
        
        return success
    }
    
    // Save and load data
    
    func saveItemToDisk(item: Item, path: String) -> Bool {
        var success = false
        
        success = NSKeyedArchiver.archiveRootObject(item, toFile: path)
        
        return success
    }
    
    func loadItemFromDisk(path: String) -> Item? {
        var result: Item? = nil
        
        result = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! Item?
        
        return result
    }
    
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        // open image picker
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        if let image = info[UIImagePickerControllerOriginalImage] as! UIImage? { // use dictionary to look up image
    
            imageView.image = image
        }
        
        // dismiss
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        print("add button pressed")
        
        // Add item to the inventory
        if let item = createItemFromInput() {
            print("item: \(item)")
            inventory.itemArray.append(item)
            
        }
        
        saveInventory()
        
    }
    
    
    var index = 0
    
    @IBAction func previousButtonPressed(sender: AnyObject) {
        
        index--
        if index < 0 {
            index = inventory.itemArray.count - 1
        }
        print("index: \(index)")

        
        let item = inventory.itemArray[index]
        displayItem(item)
        
       
    }
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        
        if inventory.itemArray.count > 0 {
            index++
            
            if index >= inventory.itemArray.count {
                index = 0
            }
            print("index: \(index)")

            
            let item = inventory.itemArray[index]
            displayItem(item)
            
            print("item: \(item)")
            //        index = index + 1
            
        }
    }
    
    func displayItem(item: Item) {
        // display the image
        if item.image != nil {
            imageView.image = item.image
        } else {
            // load the image from disk
            
            let imagePath = fileInDocumentsDirectory(item.imageName)
//            var image =
            if let image = loadImageFromPath(imagePath) {
                imageView.image = image
            } else {
                print("Error: image missing for item: \(item)")
            }
        }
        
        itemTextField.text = item.name
        costTextField.text = "\(item.cost)"
    }
    
    
    func createItemFromInput() -> Item? {
        var item: Item? = nil
        
        // validate cost
        if let cost = validateCost(costTextField.text!) {
            
            print("valid cost: \(cost)")
            
            if !itemTextField.text!.isEmpty {
                // valid title - not empty
                
                let title = itemTextField.text
                
                
                // get image (not nil)
                
                if let image = imageView.image {
                    
                    // create item and return it

                    let imageName = "\(title).jpg"
                    
                    item = Item(name: title!, cost: cost, imageName: imageName)
                    item?.image = image
                    
                } else {
                    print("Error: No image set")
                }
                
                
            } else {
                print("Error: invalid title: \(itemTextField.text)")
            }
            
            
        }
        return item
    }
    
    func validateCost(costString: String) -> Double? {
        var result: Double? = nil
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        if let cost = numberFormatter.numberFromString(costString) {
            
            // valid number of form $3.49
            result = cost.doubleValue
            
        } else {
            
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            
            if let cost = numberFormatter.numberFromString(costString) {
                // valid number of the form: 3.49
                
                result = cost.doubleValue
                
            } else {
                
                // not a valid number
                print("Error: Invalid number: \(costString)")
            }
            
        }
        
        
        return result
    }
    
    
    // Save the text data and image to disk for each valid entry.
    //  Each entry must have an item name (not empty), cost (valid number),
    //  and an image.
    //
    // If all attributes are valid, save the text data with the ItemName.txt
    //  and the image to ItemName.jpg
    //
    //
    func saveDataToDisk() {
        
        
        
        // Get text data (title and cost)
        let itemTitle = itemTextField.text
        
        // First check if the title is valid (not an empty string), otherwise we can't make a file path
        if !itemTitle!.isEmpty {
            
            // Use a number formatter to verify that we have a number value
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            
            var itemCost = numberFormatter.numberFromString(costTextField.text!)
            
            if itemCost != nil {             // Valid cost input (number)
                // If itemCost is not nil, we have a valid number
                
                // save text data to disk as a string, construct the file path using the ItemTitle.txt
                let textPath = fileInDocumentsDirectory("\(itemTitle).txt")
                
                // Get image data
                let image = imageView.image
                
                if image != nil {
                    // There is a valid image, create a file path to save it in the documents folder as a .jpg file using the ItemTitle.jpg format.
                    
                    let imagePath = fileInDocumentsDirectory("\(itemTitle).jpg")
                    
                    // Reuse the code you wrote in today's lesson
                    saveImage(image!, path: imagePath)
                    
                    // Create text to save out the data from the app to disk.
                    
                    // Create a formatted number (3.150000 becomese $3.15)
                    let itemCostFormatted = numberFormatter.stringFromNumber(itemCost!)
                    
                    // Use string interpolation to create a comma separated value string
                    var textDataToSave = "\(itemTitle), \(itemCostFormatted!), \(imagePath)"
                    
                    // Save the string to disk
                    let status = saveText(textDataToSave, path: textPath)
                    print("Saved text data: \(status) to file \(textPath)")
                    
                } else { // Error messages can be useful to explain why you can't save
                    print("Error: item image is empty")
                }
                
            } else {
                print("Error: item cost is invalid: \(costTextField.text)")
            }
        } else {
            print("Missing item title")
        }
    }

    
    // Use the methods that you wrote from today's lessons
    
    func saveImage(image: UIImage, path: String) -> Bool {
        
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        // png UIImagePNG...
        let result = jpgImageData!.writeToFile(path, atomically: true)
        return result
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("Missing image at path: \(path)")
        }
        
        return image
    }
    
    // Save text
    func saveText(text: String, path: String) -> Bool {
        var error: NSError? = nil
        let status: Bool
        do {
            try text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            status = true
        } catch let error1 as NSError {
            error = error1
            status = false
        }
        if !status { //status == false {
            print("Error saving file at path: \(path) with error: \(error?.localizedDescription)")
        }
        return status
    }
    
    // Load text
    func loadTextFromPath(path: String) -> String? {
        var error: NSError? = nil
        let text: String?
        do {
            text = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        } catch let error1 as NSError {
            error = error1
            text = nil
        }
        if text == nil {
            print("Error loading text from path: \(path) error: \(error?.localizedDescription)")
        }
        return text
    }

    
    
}

