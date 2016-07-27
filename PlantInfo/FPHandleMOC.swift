//
//  FPHandleMOC.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-26.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//
import UIKit
import CoreData

protocol FPHandlesIncomingObjects:class{
    func receiveMOC(incomingMOC: NSManagedObjectContext)
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier)
}