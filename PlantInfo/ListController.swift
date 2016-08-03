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
    private var moc:NSManagedObjectContext!
    private var bridginObjectClassifier:BridgingObjectClassifier!
    private let SEGUE_IDENTIFIER = "ToNewIdentification";
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configTableView(){
        self.coreDataTableView = self.tableView
        let request = NSFetchRequest(entityName: "Identifications")
        let countDocumentSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [countDocumentSort]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: "rootCache")
        self.performFetch()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    //MARK: Incoming object
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        moc = incomingMOC
    }
    
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        bridginObjectClassifier = incomingClassifier;
    }
    
    //MARK: UITableView Delegate
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        //let mapType = self.fetchedResultsController?.objectAtIndexPath(indexPath) as! ItemList
        
        let cell = tableView.dequeueReusableCellWithIdentifier("documentCell")
        
        
        return cell!
    }
    //MARK: Image Picker
    @IBAction func addNewIdentification(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        if(image != nil){
            performSegueWithIdentifier(SEGUE_IDENTIFIER, sender: image)
        }
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? FPHandlesIncomingObjects{
            vc.receiveClassifier(self.bridginObjectClassifier)
            vc.receiveMOC(self.moc)
        }
        
        if segue.identifier == SEGUE_IDENTIFIER,
            let vc = segue.destinationViewController as? NewIdentifierController,
                let image = sender as? UIImage{
           vc.incomingImage = image
        }
    }
}
