//
//  TabBarController.swift
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-08-08.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import UIKit
import CoreData

class TabBarController: UITabBarController, FPHandlesIncomingObjects, UITabBarControllerDelegate {
    
    private var moc:NSManagedObjectContext!
    
    override func viewDidLoad() {
        self.delegate = self
    }
    
    func receiveMOC(incomingMOC: NSManagedObjectContext) {
        self.moc = incomingMOC
        for vc in self.viewControllers!{
            if let child = vc as? FPHandlesIncomingObjects where !(vc is PhotoNavigationViewController){
                child.receiveMOC(incomingMOC)
            }
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if viewController is PhotoNavigationViewController{
            if let newVC = tabBarController.storyboard?.instantiateViewControllerWithIdentifier("PhotoNavigation") as? PhotoNavigationViewController {
                newVC.receiveMOC(self.moc)
                tabBarController.presentViewController(newVC, animated: true, completion: nil)
                return false
            }
        }
        
        return true
    }
}
