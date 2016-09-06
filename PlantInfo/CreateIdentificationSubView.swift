//
//  CreateIdentificationSubView.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-09-05.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit

class CreateIdentificationSubView: UIViewController {
    
    @IBOutlet var swiftPagesView: SwiftPages!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        // Initiation
        let VCIDs = ["CreateIdentFirstSubView", "CreateIdentSecondtSubView"]
        let buttonImages = [
        ]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let VCsInstanciated = VCIDs.map({ storyboard.instantiateViewControllerWithIdentifier($0) })
        
        // Sample customization
        swiftPagesView.initializeWithVCsInstanciatedArrayAndButtonTitlesArray(VCsInstanciated, buttonTitlesArray: ["1","2"])
        //swiftPagesView.setTopBarBackground(UIColor(red: 244/255, green: 164/255, blue: 96/255, alpha: 1.0))
        swiftPagesView.setAnimatedBarColor(UIColor.blueColor())
    }
}
