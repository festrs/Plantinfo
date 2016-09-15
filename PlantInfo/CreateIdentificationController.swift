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

protocol ReceivedPlantProtocol:class{
    func receivePlant(plant: Plant)
}

class CreateIdentificationController: UIViewController,FPHandlesIncomingObjects,CLLocationManagerDelegate,ModalTransitionDelegate,ReceivedPlantProtocol {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var plantImageView: UIImageView?
    var selectedPlant:Plant!
    var newFlag = false
    var imageIdentifier:String!
    var incomingImage:UIImage!
    var MOC:NSManagedObjectContext!
    var locationManager = CLLocationManager()
    private let SEGUE_CONTAINER = "ToContainerInfoAndPhotos"
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
        
        self.plantImageView!.image = incomingImage
        
        if newFlag {
            self.title = "New Identification"
        }else{
            self.title = "Info"
            self.navigationItem.rightBarButtonItem = nil
        }
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
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SendIndentificationController") as! SendIndentificationController
        vc.modalDelegate = self
        vc.incomingImage = incomingImage
        vc.identification = Identification(latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude, plantID: self.selectedPlant.nid)
        tr_presentViewController(vc, method: TRPresentTransitionMethod.PopTip(visibleHeight: self.view.frame.size.height*0.90), completion: {
        })
    }
    
    // MARK: - Modal viewController delegate
    func modalViewControllerDismiss(callbackData data: AnyObject? = nil) {
        tr_dismissViewController(completion: {
        })
    }
    
    //MARK: Incomings
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        self.MOC = incomingMOC
    }
    
    func receivePlant(plant: Plant) {
        self.selectedPlant = plant
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == SEGUE_CONTAINER,
            let vc = segue.destinationViewController as? ReceivedPlantProtocol{
            vc.receivePlant(self.selectedPlant) 
        }
    }
}