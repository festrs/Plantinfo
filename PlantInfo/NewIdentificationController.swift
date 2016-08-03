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

class NewIdentificationController: UIViewController,FPHandlesIncomingObjects {
    
    //MARK: - Variables
    @IBOutlet weak var pickedImageView: UIImageView!
    
    var incomingImage:UIImage!
    
    var listOfPlants:[Plant]!
    
    private let NUMBER_OF_SECTIONS = 1;
    private let REUSE_IDENTIFIER = "PlantCell"
    private let URL_IMAGE_BASE = "https://s3-sa-east-1.amazonaws.com/plantinfo/listimage/"
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
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let identificationResult = self.classifier.predictWithImage(incomingImage) as? [String]
        self.listOfPlants = plantCore.getPlantList(identificationResult!)
        
        
        for plant in listOfPlants {
            let index = listOfPlants.indexOf({$0.nid == plant.nid})!
            let imageView = self.view.viewWithTag(listOfUIImages[index]) as? UIImageView
            let label = self.view.viewWithTag(listOfLabels[index]) as? UILabel
            imageView?.kf_setImageWithURL(NSURL(string: "https://s3-sa-east-1.amazonaws.com/plantinfo/listimage/"+plant.imageLink!)!)
            label?.text = plant.info?.scientificName
        }
        
        //self.resultLabel.text = listOfPlants.map({return $0.info!.scientificName}).description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Incomings
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        self.classifier = incomingClassifier
    }
    
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        
    }
}


extension NewIdentificationController : UICollectionViewDataSource{

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPlants.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as! NewIdentificationCollectionCell
        let plant = listOfPlants[indexPath.row]
        cell.plantImageView.kf_setImageWithURL(NSURL(string: URL_IMAGE_BASE + plant.imageLink!))
        cell.plantLabel.text = plant.info?.scientificName
        return cell
    }
}
