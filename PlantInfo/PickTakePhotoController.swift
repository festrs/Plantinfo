//
//  NewPhotoController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-13.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData
import ImagePicker
import Photos
import MBProgressHUD

class PickTakePhotoController: ImagePickerController, FPHandlesIncomingObjects, ImagePickerDelegate  {
    private var moc:NSManagedObjectContext!
    private let SEGUE_IDENTIFIER = "ToSelect";
    private var imageIdentifier:String!
    private var plantsList:[Plant]?
    private lazy var plantCore = {
        return PlantCore.sharedInstance;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        imageLimit = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBarHidden = false
        resetAssets()
    }
    
    // MARK: - HUD
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Identifying..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    //MARK: Incoming object
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        moc = incomingMOC
    }
    
    //MARK: - ImagePicker Delegate Methods
    func wrapperDidPress(imagePicker: ImagePickerController, images: [UIImage], assets:[PHAsset]){}
    
    func doneButtonDidPress(imagePicker: ImagePickerController, images: [UIImage], assets:[PHAsset]){
        guard images.first != nil else {
            return
        }
        showLoadingHUD()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let predictions = BridgingObjectClassifier.sharedManager().predictWithImage(images.first) as! [String]
            self.plantsList = self.plantCore.getListOfPlantsBy(predictions)
            dispatch_async(dispatch_get_main_queue()) {
                self.hideLoadingHUD()
                if let image = images.first{
                    self.imageIdentifier = assets.first?.localIdentifier
                    self.performSegueWithIdentifier(self.SEGUE_IDENTIFIER, sender: image)
                }
            }
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
            vc.receiveMOC(self.moc)
        }
        
        if segue.identifier == SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? ResultsController,
            let image = sender as? UIImage{
            vc.incomingImage = image
            vc.imageIdentifier = imageIdentifier
            vc.listOfResults = plantsList
        }
    }
}
