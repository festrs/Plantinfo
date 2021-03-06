//
//  CustomAlbumPhoto.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-19.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import Photos

class CustomPhotoAlbum: NSObject {
    static let albumName = "Herba"
    static let sharedInstance = CustomPhotoAlbum()
    
    var assetCollection: PHAssetCollection!
    var manager = PHImageManager.defaultManager()

    
    override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.Authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                status
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    func createAlbum() {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(CustomPhotoAlbum.albumName)   // create an asset collection with the album name
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                print("error \(error)")
            }
        }
    }
    
    func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject as! PHAssetCollection
        }
        return nil
    }
    
    func saveImageAsAsset(image: UIImage, completion: (localIdentifier:String?) -> Void) {
        var placeholder: PHObjectPlaceholder?
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            
            // Request creating an asset from the image
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            // Request editing the album
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection) else {
                assert(false, "Album change request failed")
                return
            }
            // Get a placeholder for the new asset and add it to the album editing request
            guard let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else {
                assert(false, "Placeholder is nil")
                return
            }
            placeholder = photoPlaceholder
            albumChangeRequest.addAssets([photoPlaceholder])
            }, completionHandler: { success, error in
                guard let placeholder = placeholder else {
                    assert(false, "Placeholder is nil")
                    completion(localIdentifier: nil)
                    return
                }
                if success {
                    completion(localIdentifier: placeholder.localIdentifier)
                }
                else {
                    print(error)
                    completion(localIdentifier: nil)
                }
        })
    }
    
    func retrieveImageWithIdentifer(localIdentifier:String, completion: (image:UIImage?) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.Image.rawValue)
        let fetchResults = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier], options: fetchOptions)
        
        if fetchResults.count > 0 {
            if let imageAsset = fetchResults.firstObject as? PHAsset {
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = .HighQualityFormat
                manager.requestImageForAsset(imageAsset, targetSize: CGSize(width: 720, height: 1280), contentMode: .AspectFill, options: requestOptions, resultHandler: { (image, info) -> Void in
                    completion(image: image)
                })
            } else {
                completion(image: nil)
            }
        } else {
            completion(image: nil)
        }
    }
    
}