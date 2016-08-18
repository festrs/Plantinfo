//
//  NewPhotoController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-13.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData
import Fusuma

class NewPhotoController: UIViewController, FPHandlesIncomingObjects, FusumaDelegate  {
    
    private var moc:NSManagedObjectContext!
    private var bridginObjectClassifier:BridgingObjectClassifier!
    private let SEGUE_IDENTIFIER = "ToSelect";
    private var isFusumaPresented = false;
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
//            imagePicker.allowsEditing = false
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
        guard !isFusumaPresented else {
            self.tabBarController!.selectedIndex = 0
            return
        }
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusumaTintColor = UIColor.hex("#2DB434", alpha: 1.0)
        self.presentViewController(fusuma, animated: true, completion: nil)
        isFusumaPresented = true;
    }
    
    //MARK: Incoming object
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        moc = incomingMOC
    }
    
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        bridginObjectClassifier = incomingClassifier;
    }
    
    //MARK: Image Picker
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(image: UIImage) {
        performSegueWithIdentifier(SEGUE_IDENTIFIER, sender: image)
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        //self.dismissViewControllerAnimated(true, completion: nil)
        isFusumaPresented = false
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    func fusumaClosed() {
        isFusumaPresented = false
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
