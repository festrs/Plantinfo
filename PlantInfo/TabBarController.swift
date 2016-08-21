//
//  TabBarController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-08.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData

class TabBarController: UITabBarController, FPHandlesIncomingObjects {
    
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        for vc in self.viewControllers!{
            if let child = vc as? FPHandlesIncomingObjects{
                child.receiveMOC(incomingMOC)
            }
        }
    }
    
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        for vc in self.viewControllers!{
            if let child = vc as? FPHandlesIncomingObjects{
                child.receiveClassifier(incomingClassifier)
            }
        }
    }
}
