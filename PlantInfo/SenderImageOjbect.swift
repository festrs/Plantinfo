//
//  SenderImageOjbect.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-28.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore
import AWSCognito
import JWT
import Alamofire
import ObjectMapper

class SenderImage{
    
    private var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var image:UIImage!
    var identification:Identification!
    let BUCKET_NAME = "plantinfo"
    let headers = [
        "x-access-token": JWT.encode(.HS256("felipe.com.br.plantinfo.5939854fe")) { builder in
            builder.expiration = NSDate().dateByAddingTimeInterval(30*60)
        }
    ]
    
    init(image:UIImage, identification:Identification){
        self.image = image
        self.identification = identification
        self.completionHandler = { (task, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if ((error) != nil){
                    NSLog("Failed with error")
                    NSLog("Error: %@",error!);
                }
                else{
                    print("sucess")
                }
            })
        }
    }
    
    func sendImage(completion: (result: Bool) -> Void) {
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
        let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()
        image = image.resizedImageWithSize(CGSize(width: 256, height: 256 ))
        let data = UIImageJPEGRepresentation(image, 1.0)
        transferUtility.uploadData(
            data!,
            bucket:BUCKET_NAME,
            key: identification.imageLink!,
            contentType: "image/jpeg",
            expression: expression,
            completionHander: completionHandler).continueWithBlock { (task) -> AnyObject! in
                if let error = task.error {
                    NSLog("Error: %@",error.localizedDescription);
                    
                }
                if let exception = task.exception {
                    NSLog("Exception: %@",exception.description);
                    
                }
                if let _ = task.result {
                    NSLog("Upload Starting!")
                    // Do something with uploadTask.
                }
                return nil;
        }
        
        let url = urlBase + endPointAllProducts
        let objectJson = ["identification": identification.toJSON()]
        Alamofire.request(.POST, url, parameters: objectJson, headers: headers).responseJSON(completionHandler: { response in
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                completion(result: false)
                return
            }
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                print("Invalid tag information received from service")
                completion(result: false)
                return
            }
            print(responseJSON)
            completion(result: true)
        })
    }
}
