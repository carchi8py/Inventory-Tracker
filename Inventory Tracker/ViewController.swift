//
//  ViewController.swift
//  Inventory Tracker
//
//  Created by Chris Archibald on 10/1/15.
//  Copyright (c) 2015 Chris Archibald. All rights reserved.
//

import UIKit

//Documents Directory
func documentsDirectory() -> String {
    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
    return documentsFolderPath
}

// File in Documents Directory
func fileInDocumentsDirectory(filename: String) -> String {
    return documentsDirectory().stringByAppendingPathComponent(filename)
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add a tapGesture to the View
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        imageView.addGestureRecognizer(tapGesture)
        imageView.userInteractionEnabled = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }

    @IBAction func addButtonPressed(sender: AnyObject) {
        
        saveToDisk()
    }
    
    func saveToDisk() {
        let itemTitle = itemTextField.text
        
        if !itemTitle.isEmpty {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            let itemCost = numberFormatter.numberFromString(costTextField.text)
            
            if itemCost != nil {
                
                if let image = imageView.image {
                    let imagePath = fileInDocumentsDirectory("\(itemTitle).jpg")
                    saveImage(image, path: imagePath)
                    if let itemCostFormatted = numberFormatter.stringFromNumber(itemCost!) {
                        var textDataToSave = "\(itemTitle), \(itemCostFormatted), \(imagePath)"
                        println(textDataToSave)
                        
                        let textPath = fileInDocumentsDirectory("\(itemTitle).txt")
                        saveText(textDataToSave, path: textPath)
                    }
                    
                } else {
                    println("Error missing image")
                }
            } else {
                println("Error missing cost or invalid value")
            }
        } else {
            println("Error: missing item title")
        }
    }
    
   /****** Save and Load Methods ********/
    
    //Save text
    func saveText(text: String, path: String) -> Bool {
        var error: NSError? = nil
        
        let status = text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
        if !status {
            println("Error saving file at path: \(path) with error: \(error?.localizedDescription)")
        }
        return status
    }
    
    //load Text
    func loadTextFromPath(path: String) -> String? {
        var error: NSError? = nil
        let text = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: &error)
        if text == nil {
            println("Error loading text from path \(path) error: \(error)")
        }
        
        return text
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            println("Missing Image at path: \(path)")
        }
        return image
    }
    
    func saveImage(image: UIImage, path: String) -> Bool {
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        let result = jpgImageData.writeToFile(path, atomically: true)
        return result
    }
    
    /****** Image Picker Methods ********/
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        println("tap")
        
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as! UIImage? {
            imageView.image = image
        }
    }
}

