//
//  MyUINavigationController.swift
//  ToDoAssignment3
//
//  Created by Felipe Dias Pereira on 2016-04-08.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData

class NavigationViewController: UINavigationController, FPHandlesIncomingObjects {
    
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
