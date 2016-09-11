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
    @IBOutlet weak var pickedImageView: UIImageView!
    var incomingImage:UIImage!
    var imageIdentifier:String!
    var identificationResult:[String]?
    
    private let NUMBER_OF_SECTIONS = 1;
    private let REUSE_IDENTIFIER = "PlantCell"
    private let SEGUE_IDENTIFIER = "ToNewIdentification";
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
        
        for plant in listOfPlants {
            let index = listOfPredictions.indexOf({$0.nid == plant.nid})!
            let button = self.view.viewWithTag(listOfUIImages[index]) as? UIButton
            let nameLabel = self.view.viewWithTag(listOfNameLabels[index]) as? UILabel
            let probLabel = self.view.viewWithTag(listOfProbLabels[index]) as? UILabel
            
            button?.kf_setImageWithURL(NSURL(string: URL_IMAGE_BASE+plant.imageLinks![0])!, forState: .Normal, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.gradientTopDownBlack(button!)
            })
            
            //button?.kf_setImageWithURL(NSURL(string: URL_IMAGE_BASE+plant.imageLink!)!, forState: .Normal)
            
            nameLabel?.text = plant.info?.scientificName
            let probability = Double(listOfPredictions[index].probability)!
            probLabel?.text = String(format: "%.0f", probability * 100) + "%"
            buttonXPlants[button!] = plant
        }
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
