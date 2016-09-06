//
//  NewIdentifierController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-09.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
import TransitionTreasury
import TransitionAnimation

class CreateIdentificationController: UIViewController,FPHandlesIncomingObjects,CLLocationManagerDelegate,ModalTransitionDelegate {
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var poisonDeliveryModeLabel: UILabel!
    @IBOutlet weak var severityLabel: UILabel!
    @IBOutlet weak var toxityPartLabel: UILabel!
    @IBOutlet weak var commonLabel: UILabel!
    @IBOutlet weak var scientificLabel: UILabel!
    var selectedPlant:Plant!
    var imageIdentifier:String!
    var incomingImage:UIImage!
    var MOC:NSManagedObjectContext!
    var locationManager = CLLocationManager()
    private let SEGUE_IDENTIFIER = "toComment"
    var userLocation:CLLocation = CLLocation()
    var tr_presentTransition: TRViewControllerTransitionDelegate?
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
//        self.scientificLabel.text = selectedPlant.info?.scientificName
//        self.commonLabel.text = selectedPlant.info?.commonName
//        self.toxityPartLabel.text = selectedPlant.info?.poisonPart
//        self.severityLabel.text = selectedPlant.info?.severity
//        self.poisonDeliveryModeLabel.text = selectedPlant.info?.posionDeliveryMode
        self.plantImageView.image = incomingImage
    }
    
    @IBAction func saveNewIdentification(sender: AnyObject) {
        // save the image to library
        let newIdent = NSEntityDescription.insertNewObjectForEntityForName("Identifications", inManagedObjectContext: self.MOC) as! Identifications
        
        newIdent.image_ID = imageIdentifier
        newIdent.date = NSDate()
        newIdent.plant_ID = self.selectedPlant.nid
        self.saveContex()
        dispatch_async(dispatch_get_main_queue(),{
            self.dismissViewControllerAnimated(true, completion: {
                self.tabBarController?.selectedIndex = 0
            })
        })
    }
    
    func saveContex() {
        do {
            try self.MOC.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.first!
        
        manager.stopUpdatingLocation()
    }
    
    @IBAction func openModal(sender: AnyObject) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
        vc.modalDelegate = self
        vc.title = "pop"
        let nav = UINavigationController(rootViewController: vc)

        tr_presentViewController(nav, method: TRPresentTransitionMethod.PopTip(visibleHeight: 500), completion: {
            print("Present finished.")
        })
    }
    
    // MARK: - Modal viewController delegate
    
    func modalViewControllerDismiss(callbackData data: AnyObject? = nil) {
        tr_dismissViewController(completion: {
            print("Dismiss finished.")
        })
    }
    
    //MARK: Incomings
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        
    }
    
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        self.MOC = incomingMOC
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? SendIndentificationController{
            vc.incomingImage = incomingImage
            vc.identification = Identification(latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude, plantID: self.selectedPlant.nid)
        }
    }
}