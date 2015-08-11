//
//  BFFPersonDetailViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/29/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class BFFPersonDetailViewController: UIViewController {
   
    var contact : Contact?
    var shopUse : ShopUse?
    
    @IBOutlet weak var firstNameLastInitial: UILabel!
    @IBOutlet weak var membership: UILabel!
    @IBOutlet weak var totalHours: UILabel!
    @IBOutlet weak var totalHoursVolunteering: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameLastInitial.text = contact?.firstName
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let membershipExpiration = contact?.membershipExpiration
        if membershipExpiration?.timeIntervalSinceNow > 0 {
            membership.text = dateFormatter.stringFromDate(membershipExpiration!)
        } else {
            membership.text = "Membership does not exist or is expired."
        }
        totalHours.text = ShopUseLog().numberOfShopUseHoursLoggedByContact(contact!)
        
    }
}

// Mark: extension view life cycle
