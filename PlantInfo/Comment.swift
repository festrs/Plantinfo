//
//  Comment.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-28.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import ObjectMapper

class Comment: Mappable {
    
    var date:NSDate?
    var description:String?
    var flag:Int!
    
    init(description: String?, flag:Int){
        self.date = NSDate()
        self.description = description
        self.flag = flag
    }
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        date                <- (map["date"],DateTransform())
        description         <- map["description"]
        flag                <- map["flag"]
    }
}
