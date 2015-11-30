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
        let orgLog = OrganizationLog()
        let orgTypes = orgLog.currentOrganization().organization!.type
        var types = orgLog.activeTypes()
        for type in orgTypes! {
            if type.title == "employee" && type.active == true {
                types.append("Employee")
            }
        }
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
    
    func showAlertForUserType(types: [String]) {
        let alert = UIAlertController(title: "Are you here to work on your bike or volunteer", message: nil, preferredStyle: .Alert)
        let shopUse = UIAlertAction(title: types[0], style: .Default, handler: { alert in self.shopUseLog.createShopUseWithContact(self.contact!, type: types[0])
        })
        alert.addAction(shopUse)
        let volunteer = UIAlertAction(title: types[1], style: .Default, handler: { alert in self.shopUseLog.createShopUseWithContact(self.contact!, type: types[1])
        })
        alert.addAction(volunteer)
        
        if types.count > 2 {
            alert.addAction(shopUse)
            let other = UIAlertAction(title: types[2], style: .Default, handler: { alert in self.shopUseLog.createShopUseWithContact(self.contact!, type: types[2])
            })
            alert.addAction(other)
        }
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


