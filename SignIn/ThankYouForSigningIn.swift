//
//  BFFThankYouForSigningIn.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/30/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

protocol BFFThankYouForSigningInDelegate {
    func didCancelSignIn(sender: BFFThankYouForSigningIn)
}

class BFFThankYouForSigningIn: UIViewController {
    var contact : Contact!
    let shopUseLog = ShopUseLog()
    let contactLog = ContactLog()
    var delegate : BFFThankYouForSigningInDelegate?
    var currentShopUse : ShopUse?
    
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
        // this should only show up if the user navigated from the SigninVC
        if let d = delegate {
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { alert in
                d.didCancelSignIn(self)
            })
            alert.addAction(cancel)
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


