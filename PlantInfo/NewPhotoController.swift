//
//  NewPhotoController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-13.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData

class NewPhotoController: UIViewController, FPHandlesIncomingObjects, UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    private var moc:NSManagedObjectContext!
    private var bridginObjectClassifier:BridgingObjectClassifier!
    private let SEGUE_IDENTIFIER = "ToSelect";
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: Incoming object
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        moc = incomingMOC
    }
    
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        bridginObjectClassifier = incomingClassifier;
    }
    
    //MARK: Image Picker
    @IBAction func addNewIdentification(sender: AnyObject) {
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.tabBarController!.selectedIndex = 0
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        if(image != nil){
            performSegueWithIdentifier(SEGUE_IDENTIFIER, sender: image)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? FPHandlesIncomingObjects{
            vc.receiveClassifier(self.bridginObjectClassifier)
            vc.receiveMOC(self.moc)
        }
        
        if segue.identifier == SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? SelectIdentiferController,
            let image = sender as? UIImage{
            vc.incomingImage = image
        }
    }

}
