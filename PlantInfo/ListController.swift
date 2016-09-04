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
    private let SEGUE_IDENTIFIER = "ToSelect";
    
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
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: "rootCache")
        self.performFetch()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    //MARK: Incoming object
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        moc = incomingMOC
    }
    
    func receiveClassifier(incomingClassifier: BridgingObjectClassifier) {
        
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
    
}
