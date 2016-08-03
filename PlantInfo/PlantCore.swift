//
//  PlantCore.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-30.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import ObjectMapper

class PlantCore{
    
    static let sharedInstance = PlantCore()
    private var listOfPlants:[Plant] = []
    
    private init() {
        initPlants()
    }
    
    private func initPlants(){
        let plantsUrl = NSBundle.mainBundle().URLForResource("plants", withExtension: "json")
        let plantsData = NSData(contentsOfURL: plantsUrl!)
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(plantsData!, options: .AllowFragments)
            if let dictionary = object as? [String: AnyObject] {
                if let plants = dictionary["plants"] as? NSArray{
                    listOfPlants = plants.map({return Mapper<Plant>().map($0)!})
                }
            }
        } catch {
            
        }
    }
    
    func getPlantList(nids: [String]) -> [Plant]{
        return listOfPlants.filter({ nids.contains($0.nid!)})
    }
}
