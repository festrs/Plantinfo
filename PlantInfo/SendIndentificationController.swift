//
//  SendIndentificationController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-28.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import MBProgressHUD

class SendIndentificationController: UIViewController {
    var incomingImage:UIImage!
    var identification:Identification!
    var senderImageObjec:SenderImage!

    @IBOutlet weak var switchTemp: UISwitch!
    @IBOutlet weak var commentField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        senderImageObjec = SenderImage(image: incomingImage, identification: identification)
    }
    
    // MARK: - HUD
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Sending..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }

    @IBAction func sendIdentificationAndImage(sender: AnyObject) {

        let comment = Comment(description: commentField.text, flag: switchTemp.on.hashValue)
        self.identification.comments.append(comment)
        showLoadingHUD()
        senderImageObjec.sendImage { (result) in
            self.hideLoadingHUD()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
