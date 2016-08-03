//
//  NewIdentifierController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-26.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData

class NewIdentifierController: UIViewController,FPHandlesIncomingObjects {
    
    //MARK: - Variables
    @IBOutlet weak var pickedImageView: UIImageView!
    var incomingImage:UIImage!
    private var classifier:BridgingObjectClassifier!
    @IBOutlet weak var resultLabel: UILabel!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickedImageView.image = incomingImage
        resultLabel.text = self.classifier.predictWithImage(incomingImage).description
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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

    @IBAction func closeModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
