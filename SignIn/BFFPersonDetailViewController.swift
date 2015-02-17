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
   
    var contact : BCNContact!
    var shopUse : BCNShopUse!
    
    @IBOutlet weak var firstNameLastInitial: UILabel!
    @IBOutlet weak var membership: UILabel!
    @IBOutlet weak var totalHours: UILabel!
    @IBOutlet weak var totalHoursVolunteering: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameLastInitial.text = contact.description()
        if contact.membershipExpiration != nil {
            membership.text = contact.membershipExpiration.description
        } else {
            contact.membershipType = BCNMembershipType.TypeNonMember
        }
        if shopUse == nil {
            //why would shopUse be nil? oh, if going from the admin page...
            // also, should i really be creating a shop use, does each time i create one, add it to the log, or do i have to do that manually?
            var shopUse = BCNShopUse()
            shopUse.userIdentity = contact.firstName
        }
        let log = ShopUseLogSwift()
        totalHours.text = log.hoursOfShopUseByContact(contact, uniqueIdentifier:shopUse.userIdentity)
        totalHoursVolunteering.text = log.hoursOfVolunteeringByContact(contact, uniqueIdentifier: shopUse.userIdentity)
    }
}

// Mark: extension view life cycle
