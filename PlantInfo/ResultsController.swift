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

class ResultsController: UIViewController, FPHandlesIncomingObjects {
    //MARK: - Variables
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var probabilityLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    private var MOC:NSManagedObjectContext!
    var incomingImage:UIImage!
    var imageIdentifier:String!
    var listOfResults:[Plant]?
    
    private struct Keys {
        static private let NUMBER_OF_SECTIONS = 1;
        static private let REUSE_IDENTIFIER = "PlantCell"
        static private let SEGUE_IDENTIFIER = "ToNewIdentification";
        static private let NOT_POISONOUS_ID = "n12205694"
        static private let MAIN_CELL_IDENTIFIER = "mainCell"
        static private let HEIGHT_FOR_ROW = 160.0
        static private let FLAT_GREEN = "#39AF54"
        static private let FLAT_ORANGE = "#D96C00"
        static private let FLAT_RED = "#AC281C"
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = "Chances of being poisonous:"
        plantImage.image = incomingImage
        plantImage.gradientTopDownBlack()
        let proba = listOfResults?.reduce(0.0, combine: {$0.0! + $0.1.probability!} )
        probabilityLabel.text = "\(Int(proba!))%";
        if proba <= 40.0 {
            probabilityLabel.backgroundColor = UIColor.hex(Keys.FLAT_GREEN, alpha: 1.0)
        }else if(proba > 40.0 && proba <= 75.0){
            probabilityLabel.backgroundColor = UIColor.hex(Keys.FLAT_ORANGE, alpha: 1.0)
        }else{
            probabilityLabel.backgroundColor = UIColor.hex(Keys.FLAT_RED, alpha: 1.0)
        }
    }
    
    //MARK: Incomings
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        self.MOC = incomingMOC
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? FPHandlesIncomingObjects{
            vc.receiveMOC(self.MOC)
        }
        
        if segue.identifier == Keys.SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? CreateIdentificationController,
            let plant = sender as? Plant{
            vc.selectedPlant = plant
            vc.incomingImage = incomingImage
            vc.imageIdentifier = self.imageIdentifier
            vc.newFlag = true
        }
    }
}

extension ResultsController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let plant = listOfResults![indexPath.row]
        performSegueWithIdentifier(Keys.SEGUE_IDENTIFIER, sender: plant)
    }
}

extension ResultsController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(Keys.HEIGHT_FOR_ROW)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Keys.NUMBER_OF_SECTIONS
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listOfResults?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let plant = listOfResults![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(Keys.MAIN_CELL_IDENTIFIER, forIndexPath: indexPath) as! MainTableViewCell
        
        let imageNameIndex = plant.imageLinks?.indexOf { item in
            let name = item.substringFromIndex(item.startIndex.advancedBy(10))
            if UIImage(named: name.stringByReplacingOccurrencesOfString(".JPEG", withString: "")) != nil{
                return true
            }
            return false
        }

        let imageName = plant.imageLinks![imageNameIndex!].componentsSeparatedByString("/").last;
        cell.plantImage.image = UIImage(named: imageName!.stringByReplacingOccurrencesOfString(".JPEG", withString: ""));
        cell.scientificNameLabel.text = plant.info?.scientificName!
        cell.probabilityLabel.text = "\(Int(plant.probability!))%"
        
        guard let commonName = plant.info?.commonName else {
            return cell
        }
        cell.commonNameLabel.text = commonName.characters.split(",").map(String.init).first
        
        return cell;
    }
    
}


