//
//  Plants.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-30.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import ObjectMapper

class Plant: Mappable {
    
    var nid:String?
    var info:PlantInfo?
    var imageLinks:[String]?
    var probability:Double?
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        nid             <- map["_id"]
        info            <- map["id_plant_info"]
        imageLinks       <- map["image_links"]
    }
}
