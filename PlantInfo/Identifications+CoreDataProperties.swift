//
//  Identifications+CoreDataProperties.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-20.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Identifications {

    @NSManaged var date: NSDate?
    @NSManaged var image_ID: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var plant_ID: String?

}
