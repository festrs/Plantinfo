//
//  NewIdentifierController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-09.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData

class NewIdentifierController: UIViewController,FPHandlesIncomingObjects {
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var poisonDeliveryModeLabel: UILabel!
    @IBOutlet weak var severityLabel: UILabel!
    @IBOutlet weak var toxityPartLabel: UILabel!
    @IBOutlet weak var commonLabel: UILabel!
    @IBOutlet weak var scientificLabel: UILabel!
    var selectedPlant:Plant!
    var incomingImage:UIImage!
    
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
        
    }
    
    //MARK: Incomings
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {

    }
    
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        
    }
}
