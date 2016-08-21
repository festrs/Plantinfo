//
//  PlantInfo.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-30.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import ObjectMapper

class PlantInfo: Mappable {
    
    var idPlantInfo:Int?
    var commonName:String?
    var description:String?
    var family:String?
    var origin:String?
    var poisonPart:String?
    var posionDeliveryMode:String?
    var scientificName:String?
    var severity:String?
    var symptoms:String?
    var toxicPrinciple:String?
 
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        idPlantInfo         <- map["_id"]
        commonName          <- map["Common_Name"]
        description         <- map["Description"]
        family              <- map["Family"]
        origin              <- map["Origin"]
        poisonPart          <- map["Poison_Part"]
        posionDeliveryMode  <- map["Posion_Delivery_Mode"]
        scientificName      <- map["Scientific_Name"]
        symptoms            <- map["Symptoms"]
        toxicPrinciple      <- map["Toxic_Principle"]
        severity            <- map["Severity"]
    }
}