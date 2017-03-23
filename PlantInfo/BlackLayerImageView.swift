//
//  BlackLayerImageView.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2017-03-22.
//  Copyright © 2017 Felipe Dias Pereira. All rights reserved.
//

import UIKit

class BlackLayerImageView: UIImageView {
    private let overlay : UIView = UIView()
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        overlay.frame = self.bounds
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        self.addSubview(overlay)
    }

    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        overlay.frame = self.bounds
    }
    
}
