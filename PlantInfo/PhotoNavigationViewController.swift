//
//  PhotoNavigationViewController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-09-04.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData

class PhotoNavigationViewController: UINavigationController, FPHandlesIncomingObjects {
    
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        if let child = self.viewControllers.first as? FPHandlesIncomingObjects{
            child.receiveMOC(incomingMOC)
        }
    }
    
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        if let child = self.viewControllers.first as? FPHandlesIncomingObjects{
            child.receiveClassifier(incomingClassifier)
        }
    }
}