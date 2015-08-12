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
    
    override func viewDidLoad() {
        nameLabel.text = contact.firstName
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        let delay = 10.0 * Double(NSEC_PER_SEC)
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
}


