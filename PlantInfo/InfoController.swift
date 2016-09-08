//
//  infoSubViewController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-09-07.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit

class InfoController: UIViewController,ReceivedPlantProtocol,UITableViewDataSource, UITableViewDelegate {

    var plant:Plant!
    var infoPlant = [String]()
    let redInfo = ["Poison Part:","Posion Delivery Mode:","Severity:","Symptoms:"]
    let categoryList = ["Common Name:","Scientific Name:","Family:","Poison Part:","Posion Delivery Mode:","Severity:","Symptoms:"]
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //populate array with platinfo
        infoPlant.append((self.plant.info?.commonName)!)
        infoPlant.append((self.plant.info?.scientificName)!)
        infoPlant.append((self.plant.info?.family)!)
        infoPlant.append((self.plant.info?.poisonPart)!)
        infoPlant.append((self.plant.info?.posionDeliveryMode)!)
        infoPlant.append((self.plant.info?.severity)!)
        infoPlant.append((self.plant.info?.symptoms)!)
    }
    
    func receivePlant(plant: Plant) {
        self.plant = plant
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoPlant.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let info = infoPlant[indexPath.row]
        let category = categoryList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("InfoPlantCell") as? InfoPlantCell
        
        tableView.rowHeight = 60
        
        if(redInfo.contains(category)){
            cell?.categoryTitleLabel.textColor = UIColor.redColor()
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
