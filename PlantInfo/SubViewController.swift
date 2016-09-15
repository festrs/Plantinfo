//
//  CreateIdentificationSubView.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-09-05.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit

class SubViewController: UIViewController, ReceivedPlantProtocol {
    
    @IBOutlet var swiftPagesView: SwiftPages!
    var plant:Plant!
    
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
        
        // Sample customization
        swiftPagesView.setTopBarBackground(UIColor.clearColor())
        swiftPagesView.setAnimatedBarColor(UIColor.hex("#2ea75f", alpha: 1.0))
        swiftPagesView.initializeWithVCsInstanciatedArrayAndButtonTitlesArray(VCsInstanciated, buttonTitlesArray: ["Info","Photos"])
    }
    
    
    func receivePlant(plant: Plant) {
        self.plant = plant
    }
}
