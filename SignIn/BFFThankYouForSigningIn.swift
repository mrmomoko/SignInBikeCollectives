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
    var shopUse : ShopUse!
    var delegate : BFFThankYouForSigningInDelegate! = nil
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let delay = 10.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            if self.delegate != nil {
//            self.delegate.viewControllerDidTimeOutWithUser(self, user: self.contact)
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let segueIdentifier = segue.identifier
        
        if segueIdentifier == "User Info" {
            let vc = segue.destinationViewController as! BFFPersonDetailViewController
            vc.contact = contact;
//            vc.shopUse = shopUse;
        }
    }
}

@objc protocol BFFThankYouForSigningInDelegate {
    func viewControllerDidTimeOutWithUser(controller:BFFThankYouForSigningIn,user:BCNContact)
}


