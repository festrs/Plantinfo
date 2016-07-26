//
//  ViewController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-05.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import JWT
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var bridginObject = BridgingObject.sharedManager()
        
        print(bridginObject.predictWithImage(UIImage(imageLiteral: "n12899752_5266.JPEG")))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendInfoToServer(){
        let url = urlBase + endPointAllProducts
        let headers = [
            "x-access-token": JWT.encode(.HS256("felipe.com.br.plantinfo.5939854fe")) { builder in
                builder.expiration = NSDate().dateByAddingTimeInterval(30*60)
            }
        ]
        //	
//        date: 					{ type: Date, default: Date.now },
//        local: 					{ type: mongoose.Schema.Types.ObjectId, ref: 'local'},
//        plant: 					{ type: String, ref: 'plant'},
//        comments:				[{ type: mongoose.Schema.Types.ObjectId, ref: 'comment'}]
//        
//  comment      date: 					{ type: Date, default: Date.now },
//              description: 			{ type: String, required: true},
//              flag: 	 				{ type: Number, require: true}
        
        let parameters = [
            "identification": [
                "date": NSDate(),
                "local": ["latitude": 111111, "longitude" : 111111],
                "id_plant": "n11725973",
                "image_link": "n11725973/test",
                "comments": ["1": ["date":NSDate(), "description": "teste description", "flag":1]]
            ]
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, headers: headers).responseJSON(completionHandler: { response in
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                //self.hideLoadingHUD()
                return
            }
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                print("Invalid tag information received from service")
                //self.hideLoadingHUD()
                return
            }
            print(responseJSON)

        })
    }

    @IBAction func clickButton(sender: AnyObject) {
        sendInfoToServer();
    }

}

