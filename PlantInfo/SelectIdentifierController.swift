//
//  NewIdentifierController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-26.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import Spring

class SelectIdentiferController: UIViewController, FPHandlesIncomingObjects {
    
    //MARK: - Variables
    @IBOutlet weak var pickedImageView: UIImageView!
    
    var incomingImage:UIImage!
    
    var listOfPlants:[Plant]!
    
    private let NUMBER_OF_SECTIONS = 1;
    private let REUSE_IDENTIFIER = "PlantCell"
    private let URL_IMAGE_BASE = "https://s3-sa-east-1.amazonaws.com/plantinfo/listimage/"
    private let SEGUE_IDENTIFIER = "ToNewIdentification";
    var buttonXPlants:[UIButton: Plant] = [:]
    let listOfLabels = [60,61,62,63,64]
    let listOfUIImages = [50,51,52,53,54]
    
    private var classifier:BridgingObjectClassifier!
    private lazy var plantCore = {
       return PlantCore.sharedInstance;
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickedImageView.image = incomingImage
        let identificationResult = self.classifier.predictWithImage(incomingImage) as? [String]
        self.listOfPlants = plantCore.getPlantList(identificationResult!)
        for plant in listOfPlants {
            let index = listOfPlants.indexOf({$0.nid == plant.nid})!
            let button = self.view.viewWithTag(listOfUIImages[index]) as? UIButton
            let label = self.view.viewWithTag(listOfLabels[index]) as? UILabel
            
            button?.kf_setImageWithURL(NSURL(string: URL_IMAGE_BASE+plant.imageLink!)!, forState: .Normal)
            
            gradientTopDownBlack(button!)
            
            label?.text = plant.info?.scientificName
            buttonXPlants[button!] = plant
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.resultLabel.text = listOfPlants.map({return $0.info!.scientificName}).description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gradientTopDownBlack(sender: UIButton){
        let myGradientLayer = CAGradientLayer()
        myGradientLayer.frame = (sender.imageView?.layer.frame)!
        let colors: [CGColorRef] = [
            UIColor.clearColor().CGColor,
            UIColor.clearColor().CGColor,
            UIColor.blackColor().CGColor]
        myGradientLayer.colors = colors
        myGradientLayer.opaque = false
        myGradientLayer.locations = [0.0, 0.5, 1.0]
        sender.layer.insertSublayer(myGradientLayer, above: sender.imageView?.layer)
    }
    
    //MARK: Incomings
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        self.classifier = incomingClassifier
    }
    
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        
    }
    
    //MARK: IMAGES TAP
    @IBAction func buttonTap(sender: AnyObject) {
        if let button = sender as? UIButton {
            if let plant = buttonXPlants[button] {
                performSegueWithIdentifier(SEGUE_IDENTIFIER, sender: plant)
            }
        }
        
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? FPHandlesIncomingObjects{
//            vc.receiveClassifier(self.bridginObjectClassifier)
//            vc.receiveMOC(self.moc)
        }
        
        if segue.identifier == SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? NewIdentifierController,
            let plant = sender as? Plant{
            vc.selectedPlant = plant
        }
    }
    
    
}
