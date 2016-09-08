//
//  NewPhotoController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-13.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData
import ALCameraViewController
import ImagePicker
import Photos

class PhotoController: ImagePickerController, FPHandlesIncomingObjects, ImagePickerDelegate  {
    
    private var moc:NSManagedObjectContext!
    private var bridginObjectClassifier:BridgingObjectClassifier!
    private let SEGUE_IDENTIFIER = "ToSelect";
    private var imageIdentifier:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.imageLimit = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    //MARK: Incoming object
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        moc = incomingMOC
    }
    
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        bridginObjectClassifier = incomingClassifier;
    }
    
    //MARK: - ImagePicker Delegate Methods
    func wrapperDidPress(imagePicker: ImagePickerController, images: [UIImage], assets:[PHAsset]){}
    
    func doneButtonDidPress(imagePicker: ImagePickerController, images: [UIImage], assets:[PHAsset]){
        if let image = images.first{
            self.imageIdentifier = assets.first?.localIdentifier
            self.performSegueWithIdentifier(self.SEGUE_IDENTIFIER, sender: image)
            self.resetAssets()
        }
    }
    
    func cancelButtonDidPress(imagePicker: ImagePickerController){
        imagePicker.dismissViewControllerAnimated(true, completion: {
            self.tabBarController?.selectedIndex = 0
        })
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? FPHandlesIncomingObjects{
            vc.receiveClassifier(self.bridginObjectClassifier)
            vc.receiveMOC(self.moc)
        }
        
        if segue.identifier == SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? SelectPlantController,
            let image = sender as? UIImage{
            vc.incomingImage = image
            vc.imageIdentifier = self.imageIdentifier
        }
    }
}
