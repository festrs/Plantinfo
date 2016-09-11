//
//  SendIndentificationController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-28.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import MBProgressHUD
import TransitionTreasury
import M13Checkbox

class SendIndentificationController: UIViewController, UITextFieldDelegate {
    var incomingImage:UIImage!
    var identification:Identification!
    var senderImageObjec:SenderImage!
     
    @IBOutlet weak var checkBoxView: M13Checkbox!
    @IBOutlet weak var commentTextField: UITextView!
    weak var modalDelegate: ModalViewControllerDelegate?
    
    lazy var dismissGestureRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ModalViewController.panDismiss(_:)))
        self.view.addGestureRecognizer(pan)
        return pan
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.becomeFirstResponder()
        senderImageObjec = SenderImage(image: incomingImage, identification: identification)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func dismissClick(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(callbackData: ["title":title ?? ""])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func panDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began :
            guard sender.translationInView(view).y < 0 else {
                break
            }
            modalDelegate?.modalViewControllerDismiss(interactive: true, callbackData: nil)
        default : break
        }
    }
    
    // MARK: - HUD
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Sending..."
        hud.yOffset = 30.0
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }

    @IBAction func sendIdentificationAndImage(sender: AnyObject) {
        let flagChecked = checkBoxView.checkState == .Checked ? 1 : 0
        let comment = Comment(description: commentTextField.text, flag:flagChecked)
        self.identification.comments.append(comment)
        showLoadingHUD()
        senderImageObjec.sendImage { (result) in
            self.hideLoadingHUD()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
