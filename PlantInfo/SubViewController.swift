//
//  CreateIdentificationSubView.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-09-05.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import ReachabilitySwift

class SubViewController: UIViewController, ReceivedPlantProtocol, SwiftPagesDelegate {
    
    @IBOutlet var swiftPagesView: SwiftPages!
    var plant:Plant!
    var reachability: Reachability!
    var internetReachability = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        // Initiation
        let VCIDs = ["InfoController", "PhotosSubView"]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let VCsInstanciated = VCIDs.map({ storyboard.instantiateViewControllerWithIdentifier($0) })
        
        VCsInstanciated.forEach({
            if let vc = $0 as? ReceivedPlantProtocol{
                vc.receivePlant(self.plant)
            }
        })
        
        swiftPagesView.delegate = self
        swiftPagesView.setTopBarBackground(UIColor.clearColor())
        swiftPagesView.setAnimatedBarColor(UIColor.hex("#2ea75f", alpha: 1.0))
        swiftPagesView.initializeWithVCsInstanciatedArrayAndButtonTitlesArray(VCsInstanciated, buttonTitlesArray: ["Info","Photos"])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(SubViewController.reachabilityChanged(_:)),
                                                         name: ReachabilityChangedNotification,
                                                         object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("This is not working.")
            return
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        internetReachability = reachability.isReachable()
    }
    
    func SwiftPagesCurrentPageNumber(currentIndex: Int) {
        if currentIndex == 1 && !internetReachability{
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet to see the photos.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    
    func receivePlant(plant: Plant) {
        self.plant = plant
    }
    
    
}
