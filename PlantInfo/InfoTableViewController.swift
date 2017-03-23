//
//  infoSubViewController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-09-07.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit

class InfoTableViewController: UIViewController,ReceivedPlantProtocol,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var plant:Plant!
    var infoPlant = [String:AnyObject]()
    let redInfo = ["Poison Part:","Posion Delivery Mode:","Severity:","Symptoms:"]
    let categoryList = ["Common_Name":"Common Name:",
                        "Scientific_Name":"Scientific Name:",
                        "Family":"Family:",
                        "Poison_Part":"Poison Part:",
                        "Posion_Delivery_Mode":"Posion Delivery Mode:",
                        "Severity":"Severity:",
                        "Symptoms":"Symptoms:"]
    let order = [0:"Common_Name",
                 1:"Scientific_Name",
                 2:"Family",
                 3:"Poison_Part",
                 4:"Posion_Delivery_Mode",
                 5:"Severity",
                 6:"Symptoms"]
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        infoPlant = self.plant.info.map({
            return $0.toJSON()
        })!
        self.tableView.rowHeight = 60
    }
    
    func receivePlant(plant: Plant) {
        self.plant = plant
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let key = order[indexPath.row]!
        let category = categoryList[key]
        let info = infoPlant[key] as? String
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InfoPlantCell") as? InfoPlantCell
        
        if(redInfo.contains(category!)){
            cell?.categoryTitleLabel.textColor = UIColor.redColor()
        }else{
            cell?.categoryTitleLabel.textColor = UIColor.blackColor()
        }
        
        cell?.categoryTitleLabel.text = category
        cell?.plantDetailLabel.text = info
        
        return cell!
    }
}


class InfoPlantCell: UITableViewCell{
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var plantDetailLabel: UILabel!
    
}
