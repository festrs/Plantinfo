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
        guard !isFusumaPresented else {
            self.tabBarController!.selectedIndex = 0
            return
        }
        let fusuma = FusumaViewController()
        fusuma.modeOrder = .CameraFirst
        fusuma.delegate = self
        fusumaTintColor = UIColor.hex("#2DB434", alpha: 1.0)
        self.presentViewController(fusuma, animated: true, completion: {
            self.isFusumaPresented = true;
        })
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
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        isFusumaPresented = false
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
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
