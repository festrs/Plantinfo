//
//  ListController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-26.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData

class ListController: CoreDataTableViewController, FPHandlesIncomingObjects {
    //MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    private var MOC:NSManagedObjectContext!
    private let SEGUE_IDENTIFIER = "ToIdentifierPlant";
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.performFetch()
    }
    
    func configTableView(){
        self.coreDataTableView = self.tableView
        let request = NSFetchRequest(entityName: "Identifications")
        let countDocumentSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [countDocumentSort]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.MOC, sectionNameKeyPath: nil, cacheName: "rootCache")
        self.performFetch()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = 65
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "info-background")!)
        self.tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    //MARK: Incoming object
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        self.MOC = incomingMOC
    }
    
    //MARK: UITableView Delegate
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        let identificationObj = self.fetchedResultsController?.objectAtIndexPath(indexPath) as! Identifications
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IdentificationCell") as! ListCellController
        
        if let identifier = identificationObj.image_ID {
            CustomPhotoAlbum.sharedInstance.retrieveImageWithIdentifer(identifier, completion: { (image) -> Void in
                dispatch_async(dispatch_get_main_queue(),{
                    cell.photoImageView.image = image
                    cell.setNeedsLayout()
                })
            })
        }
        let plant = PlantCore.sharedInstance.getPlantByID(identificationObj.plant_ID!)
        cell.photoImageView.image = UIImage(named: "default-placeholder")
        cell.scientificNameLabel.text = plant.info?.scientificName
        cell.detailLabel.text = NSDateFormatter.localizedStringFromDate(identificationObj.date!, dateStyle: .ShortStyle, timeStyle: .NoStyle)
        cell.setEditing(false, animated: false)
        
        guard let commonName = plant.info?.commonName else {
            return cell
        }
        cell.titleLabel.text = commonName.characters.split(",").map(String.init).first
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let identification = self.fetchedResultsController!.objectAtIndexPath(indexPath) as! Identifications

            self.MOC.deleteObject(identification)

            self.performFetch()
            self.tableView.reloadData()
            
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? FPHandlesIncomingObjects{
            vc.receiveMOC(self.MOC)
        }
        
        if segue.identifier == SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? CreateIdentificationController,
            let cell = sender as? ListCellController{
            let index = self.tableView.indexPathForCell(cell)
            let identificationObj = self.fetchedResultsController?.objectAtIndexPath(index!) as! Identifications
            vc.selectedPlant = PlantCore.sharedInstance.getPlantByID(identificationObj.plant_ID!)
            vc.incomingImage = cell.photoImageView?.image
            vc.imageIdentifier = identificationObj.image_ID
        }
    }
    
}

class ListCellController : UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    
    override func layoutSubviews() {
        self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width / 2
        self.photoImageView.clipsToBounds = true
    }
    
}
