//
//  PhotosController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-09-08.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import Kingfisher
import ReachabilitySwift

class PhotosController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,ReceivedPlantProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var plant:Plant!
    private let reuseIdentifier = "photoCell"
    @IBOutlet var photsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width / 2.0
            let itemHeight = layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth-7, height: itemHeight)
            layout.invalidateLayout()
        }
    }
    
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
            cell.plantImageView.kf_setImageWithURL(NSURL(string: URL_IMAGE_BASE+plant.imageLinks![indexPath.row])!, placeholderImage: UIImage(named: "default-placeholder"), optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
                
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
