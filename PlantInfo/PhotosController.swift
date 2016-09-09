//
//  PhotosController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-09-08.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import ImageViewer

class PhotosController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,ReceivedPlantProtocol {

    private var plant:Plant!
    private let reuseIdentifier = "photoCell"
    @IBOutlet var photsCollection: UICollectionView!
    
    
    class SomeImageProvider: ImageProvider {
        let images = [
            UIImage(named: "0"),
            UIImage(named: "1"),
            UIImage(named: "2"),
            UIImage(named: "3"),
            UIImage(named: "4"),
            UIImage(named: "5"),
            UIImage(named: "6"),
            UIImage(named: "7"),
            UIImage(named: "8"),
            UIImage(named: "9")]
        
        var imageCount: Int {
            return images.count
        }
        
        func provideImage(completion: UIImage? -> Void) {
            completion(UIImage(named: "image_big"))
        }
        
        func provideImage(atIndex index: Int, completion: UIImage? -> Void) {
            completion(images[index])
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
        return 6
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) ->
        UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier,
            forIndexPath: indexPath)
            
            // Configure the cell
            
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        let imageProvider = SomeImageProvider()
        let buttonAssets = CloseButtonAssets(normal: UIImage(named:"close_normal")!, highlighted: UIImage(named: "close_highlighted"))
        let configuration = ImageViewerConfiguration(imageSize: CGSize(width: 1920, height: 1080), closeButtonAssets: buttonAssets)
        
        let imageViewer = ImageViewerController(imageProvider: imageProvider, configuration: configuration, displacedView: cell!)
        self.presentImageViewer(imageViewer)
    }
    
    
}
