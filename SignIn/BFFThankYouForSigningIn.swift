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
    @IBOutlet weak var nameLabel: UILabel!
    
//    override func init(coder aDecoder: NSCoder) {
//        nameLabel.text = contact!.firstName
//    }
    
    override func viewDidAppear(animated: Bool) {
        nameLabel.text = contact.firstName
        let delay = 10.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            println("something happened")
        }
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let segueIdentifier = segue.identifier
        
        if segueIdentifier == "User Info" {
            let vc = segue.destinationViewController as! BFFPersonDetailViewController
            vc.contact = contact;

        }
    }
}


