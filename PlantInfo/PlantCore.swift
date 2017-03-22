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
    private let NOT_POISONOUS_ID = "n12205694"
    
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
    
    func getPlantByID(id: String) -> Plant{
        return listOfPlants.filter({
            $0.nid! == id
        }).first!
    }
    
    func getListOfPlantsBy(identificationResult: [String]) -> [Plant]{
        let arrayResult = identificationResult.map { (string) -> PredictInfo in
            var probability = string.characters.split(";").map(String.init).last
            if probability!.containsString("e") {
                probability = "0"
            }
            return PredictInfo(nid: string.characters.split(";").map(String.init).first, probability: Double(probability!))
        }
        
        let predictions = Dictionary(keyValuePairs: arrayResult.map{($0.nid, $0)})
        
        return listOfPlants.filter({
            if let val = predictions[$0.nid!] where $0.nid! != NOT_POISONOUS_ID {
                $0.probability = (val.probability * 100)
                return true
            }
            return false
        }).sort({$0.probability > $1.probability})
    }
}
