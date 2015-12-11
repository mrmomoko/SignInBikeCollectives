//
//  BFFThankYouForSigningIn.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/30/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class BFFThankYouForSigningIn: UIViewController {
    var contact : Contact!
    let shopUseLog = ShopUseLog()
    let contactLog = ContactLog()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        nameLabel.text = contact.firstName
        let types = TypeLog().getAllActiveTypesForGroup("Contact")
        showAlertForUserType(types)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.dismissViewControllerAfterTimeOut()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueIdentifier = segue.identifier
        
        if segueIdentifier == "User Info" {
            let vc = segue.destinationViewController as! PersonDetailViewController
            vc.contact = contact;
        }
    }
    
    func showAlertForUserType(types: [Type]) {
        
        let alert = UIAlertController(title: "How are you using the shop today?", message: nil, preferredStyle: .Alert)
        var i = 0
        while i < types.count {
            let counter = i
            let shopUse = UIAlertAction(title: types[i].title, style: .Default, handler: { alert in self.shopUseLog.createShopUseWithContact(self.contact!, id: Int(types[counter].id!))
            })
            alert.addAction(shopUse)
            i = i + 1
        }
//            if types.count > 1 {
//                let volunteer = UIAlertAction(title: types[1].title, style: .Default, handler: { alert in self.shopUseLog.createShopUseWithContact(self.contact!, id: Int(types[0].id!))
//                })
//                alert.addAction(volunteer)
//            }
//            if types.count > 2 {
//                alert.addAction(shopUse)
//                let other = UIAlertAction(title: types[2].title, style: .Default, handler: { alert in self.shopUseLog.createShopUseWithContact(self.contact!, id: Int(types[0].id!))
//                })
//                alert.addAction(other)
//            }
        presentViewController(alert, animated: true, completion: nil)
        
   }
    
    func dismissViewControllerAfterTimeOut() {
        let delay = 15.0 * Double(NSEC_PER_SEC) // change to *15 sec
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            if self.navigationController?.topViewController == self {
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
        }
    }
}


