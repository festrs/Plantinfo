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

class SelectPlantController: UIViewController, FPHandlesIncomingObjects {
    //MARK: - Variables
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var pickedImageView: UIImageView!
    var incomingImage:UIImage!
    var imageIdentifier:String!
    var identificationResult:[String]?
    
    private let NUMBER_OF_SECTIONS = 1;
    private let REUSE_IDENTIFIER = "PlantCell"
    private let SEGUE_IDENTIFIER = "ToNewIdentification";
    private let NOTPOISONOUS_ID = "n12205694"
    private var buttonXPlants:[UIButton: Plant] = [:]
    private let listOfProbLabels = [70,71,72,73,74]
    private let listOfNameLabels = [60,61,62,63,64]
    private let listOfUIImages = [50,51,52,53,54]

    private var MOC:NSManagedObjectContext!
    private lazy var plantCore = {
       return PlantCore.sharedInstance;
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickedImageView.image = incomingImage
        let listOfPredictions = plantCore.getListOfPredictions(identificationResult!)
        let listOfPlants = plantCore.getPlantList(listOfPredictions)
        
        print(listOfPlants.map { return $0.nid } );
        
        var proba = 0.0;
        for plant in listOfPlants {
            let index = listOfPredictions.indexOf({$0.nid == plant.nid})!
            if(plant.nid == NOTPOISONOUS_ID){
                print("NOT POISONOUS")
            }
            let imageName = plant.imageLinks![0].componentsSeparatedByString("/").last;
            let plantImage = UIImage(named: imageName!.stringByReplacingOccurrencesOfString(".JPEG", withString: ""));
            proba = proba + (listOfPredictions[index].probability * 100)
        }
        
        percentageLabel.text = "\(proba)";
        if(proba <= 40.0){
            percentageLabel.backgroundColor = UIColor.greenColor()
        }else if(proba > 40.0 && proba <= 75.0){
            percentageLabel.backgroundColor = UIColor.yellowColor()
        }else{
            percentageLabel.backgroundColor = UIColor.redColor()
        }
        
        
        print(proba)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gradientTopDownBlack(sender: UIView){
        let myGradientLayer = CAGradientLayer()
        myGradientLayer.frame = sender.layer.frame
        let colors: [CGColorRef] = [
            UIColor.clearColor().CGColor,
            UIColor.clearColor().CGColor,
            UIColor.blackColor().CGColor]
        myGradientLayer.colors = colors
        myGradientLayer.opaque = true
        myGradientLayer.locations = [0.0, 0.5, 1.0]
        sender.layer.insertSublayer(myGradientLayer, above: sender.layer)
    }
    
    //MARK: Incomings
    
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        self.MOC = incomingMOC
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
            vc.receiveMOC(self.MOC)
        }
        
        if segue.identifier == SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? CreateIdentificationController,
            let plant = sender as? Plant{
            vc.selectedPlant = plant
            vc.incomingImage = incomingImage
            vc.imageIdentifier = self.imageIdentifier
            vc.newFlag = true
        }
    }
    
    
}
