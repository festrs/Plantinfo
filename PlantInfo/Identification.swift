//
//  Identification.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-28.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import ObjectMapper

class Identification: Mappable {
    
    var date:NSDate?
    var local:Local?
    var plantID:String?
    var imageLink:String?
    var comments: [Comment] = []
    
    init(latitude:Double,longitude:Double, plantID:String?){
        self.date = NSDate()
        self.local = Local(latitude: latitude, longitude: longitude)
        self.plantID = plantID
        
        let uuid = NSUUID().UUIDString
        let nid = plantID?.stringByReplacingOccurrencesOfString("n", withString: "")
        self.imageLink = "newimages/"+nid!+"/"+uuid+".jpeg"
    }
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        date                <- (map["date"],DateTransform())
        local               <- map["local"]
        plantID             <- map["id_plant"]
        imageLink           <- map["image_link"]
        comments            <- map["comments"]
    }
}

class Local : Mappable {
    
    var latitude:Double!
    var longitude:Double!
    
    init(latitude:Double!, longitude:Double!){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        latitude             <- map["latitude"]
        longitude               <- map["longitude"]
    }
}