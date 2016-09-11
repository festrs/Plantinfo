//
//  PhotosController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-09-08.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import Kingfisher

class PhotosController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,ReceivedPlantProtocol {

    private var plant:Plant!
    private let reuseIdentifier = "photoCell"
    @IBOutlet var photsCollection: UICollectionView!
    
    func receivePlant(plant: Plant) {
        self.plant = plant
    }
    
    func numberOfSectionsInCollectionView(collectionView:
        UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return (plant.imageLinks?.count)!
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) ->
        UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier,
            forIndexPath: indexPath) as! PhotosCellController
            
            // Configure the cell
            cell.plantImageView.kf_setImageWithURL(NSURL(string: URL_IMAGE_BASE+plant.imageLinks![indexPath.row])!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
                
            }
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotosCellController
    }
}


class PhotosCellController : UICollectionViewCell{
    
    @IBOutlet weak var plantImageView: UIImageView!
    
    
}
