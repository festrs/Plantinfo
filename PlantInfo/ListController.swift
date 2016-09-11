//
//  ListController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-26.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData

class ListController: CoreDataTableViewController, FPHandlesIncomingObjects, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    //MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    private var MOC:NSManagedObjectContext!
    private let SEGUE_IDENTIFIER = "ToIdentifierPlant";
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IdentificationCell")
        
        if let identifier = identificationObj.image_ID {
            CustomPhotoAlbum.sharedInstance.retrieveImageWithIdentifer(identifier, completion: { (image) -> Void in
                dispatch_async(dispatch_get_main_queue(),{
                    cell?.imageView?.image = image
                    cell?.setNeedsLayout()
                })
            })
        }
        let plant = PlantCore.sharedInstance.getPlantByID(identificationObj.plant_ID!)
        cell?.textLabel?.text = plant.info?.scientificName
        cell?.detailTextLabel?.text = NSDateFormatter.localizedStringFromDate(identificationObj.date!, dateStyle: .ShortStyle, timeStyle: .NoStyle)
        return cell!
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? FPHandlesIncomingObjects{
            vc.receiveMOC(self.MOC)
        }
        
        if segue.identifier == SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? CreateIdentificationController,
            let cell = sender as? UITableViewCell{
            let index = self.tableView.indexPathForCell(cell)
            let identificationObj = self.fetchedResultsController?.objectAtIndexPath(index!) as! Identifications
            vc.selectedPlant = PlantCore.sharedInstance.getPlantByID(identificationObj.plant_ID!)
            vc.incomingImage = cell.imageView?.image
            vc.imageIdentifier = identificationObj.image_ID
        }
    }
    
}
