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
    private var classifier:BridgingObjectClassifier!
    private let SEGUE_IDENTIFIER = "ToIdentifierPlant";
    private lazy var plantCore = {
        return PlantCore.sharedInstance;
    }()
    
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
    
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        self.classifier = incomingClassifier
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
        cell?.textLabel?.text = identificationObj.plant_ID
        
        return cell!
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? FPHandlesIncomingObjects{
            vc.receiveClassifier(self.classifier)
            vc.receiveMOC(self.MOC)
        }
        
        if segue.identifier == SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? CreateIdentificationController,
            let cell = sender as? UITableViewCell{
            let index = self.tableView.indexPathForCell(cell)
            let identificationObj = self.fetchedResultsController?.objectAtIndexPath(index!) as! Identifications
            let fakePredict = PredictInfo(nid: identificationObj.plant_ID, probability: "")
            
            vc.selectedPlant = plantCore.getPlantList([fakePredict]).first
            vc.incomingImage = cell.imageView?.image
            vc.imageIdentifier = identificationObj.image_ID
        }
    }
    
}
