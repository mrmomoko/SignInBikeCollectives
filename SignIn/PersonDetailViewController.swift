//
//  BFFPersonDetailViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/29/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class PersonDetailViewController: UIViewController {
   
    var contact : Contact?
    var shopUse : ShopUse?
    
    @IBOutlet weak var firstNameLastInitial: UILabel!
    @IBOutlet weak var membership: UILabel!
    @IBOutlet weak var totalHours: UILabel!
    @IBOutlet weak var totalHoursVolunteering: UILabel!

    @IBOutlet weak var thisMonthShopUse: UILabel!
    @IBOutlet weak var thisMonthVolunteering: UILabel!
    
    @IBOutlet weak var lastMonthShopUse: UILabel!
    @IBOutlet weak var lastMonthVolunteering: UILabel!
    
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
        totalHoursVolunteering.text = ShopUseLog().numberOfVolunteerHoursLoggedByContact(contact!)
        thisMonthShopUse.text = "no data yet"
        thisMonthVolunteering.text = "no data yet"
        lastMonthShopUse.text = "no data yet"
        lastMonthVolunteering.text = "no data yet"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit User Segue" {
            let vc = segue.destinationViewController as! EditUserViewController
            vc.contact = contact
        }
    }
}

