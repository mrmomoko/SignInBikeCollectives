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
           showAlertForCompleteForm()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        let delay = 5.0 * Double(NSEC_PER_SEC) // change to *15 sec
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            if self.navigationController?.topViewController == self {
            self.navigationController!.popToRootViewControllerAnimated(true)
            }
        }
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let segueIdentifier = segue.identifier
        
        if segueIdentifier == "User Info" {
            let vc = segue.destinationViewController as! PersonDetailViewController
            vc.contact = contact;
        }
    }
    func showAlertForCompleteForm () {
        let alert = UIAlertController(title: "Are you here to work on your bike or volunteer", message: nil, preferredStyle: .Alert)
        let shopUse = UIAlertAction(title: "Use the Shop", style: .Default, handler: { alert in self.shopUseLog.createShopUseWithContact(self.contact!)
        })
        alert.addAction(shopUse)
        let volunteer = UIAlertAction(title: "Volunteer", style: .Default, handler: { alert in self.shopUseLog.createVolunteerUseWithContact(self.contact!)
        })
        alert.addAction(volunteer)
        presentViewController(alert, animated: true, completion: nil)
    }
}


