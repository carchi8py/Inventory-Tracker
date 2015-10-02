//
//  ViewController.swift
//  Inventory Tracker
//
//  Created by Chris Archibald on 10/1/15.
//  Copyright (c) 2015 Chris Archibald. All rights reserved.
//

import UIKit

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
    }
    
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

