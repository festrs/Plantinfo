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
import Dispatch

class NewIdentifierController: UIViewController,FPHandlesIncomingObjects,CLLocationManagerDelegate {
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var poisonDeliveryModeLabel: UILabel!
    @IBOutlet weak var severityLabel: UILabel!
    @IBOutlet weak var toxityPartLabel: UILabel!
    @IBOutlet weak var commonLabel: UILabel!
    @IBOutlet weak var scientificLabel: UILabel!
    var selectedPlant:Plant!
    var incomingImage:UIImage!
    var MOC:NSManagedObjectContext!
    var locationManager = CLLocationManager()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scientificLabel.text = selectedPlant.info?.scientificName
        self.commonLabel.text = selectedPlant.info?.commonName
        self.toxityPartLabel.text = selectedPlant.info?.poisonPart
        self.severityLabel.text = selectedPlant.info?.severity
        self.poisonDeliveryModeLabel.text = selectedPlant.info?.posionDeliveryMode
        self.plantImageView.image = incomingImage
    }
    
    @IBAction func saveNewIdentification(sender: AnyObject) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        var identifier:String?
        
        // save the image to library
        
        CustomPhotoAlbum.sharedInstance.saveImageAsAsset(incomingImage, completion: { (localIdentifier) -> Void in
            identifier = localIdentifier
            let newIdent = NSEntityDescription.insertNewObjectForEntityForName("Identifications", inManagedObjectContext: self.MOC) as! Identifications
            
            newIdent.image_ID = localIdentifier
            newIdent.date = NSDate()
            newIdent.plant_ID = self.selectedPlant.nid
            self.saveContex()
            dispatch_async(dispatch_get_main_queue(),{
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.popToRootViewControllerAnimated(true)
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
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations.first!
        
        manager.stopUpdatingLocation()
    }
    
    //MARK: Incomings
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        
    }
    
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        self.MOC = incomingMOC
    }
}