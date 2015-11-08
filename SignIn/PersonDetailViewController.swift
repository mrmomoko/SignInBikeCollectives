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
    let shopUseLog = ShopUseLog()
    
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
        self.dismissViewControllerAfterTimeOut()
        firstNameLastInitial.text = contact?.firstName
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let membershipExpiration = contact?.membership!.membershipExpiration
        if membershipExpiration?.timeIntervalSinceNow > 0 {
            membership.text = dateFormatter.stringFromDate(membershipExpiration!)
        } else {
            membership.text = "Membership does not exist or is expired."
        }
        totalHours.text = shopUseLog.numberOfShopUseHoursLoggedByContact(contact!)
        totalHoursVolunteering.text = shopUseLog.numberOfVolunteerHoursLoggedByContact(contact!)
        thisMonthShopUse.text = shopUseLog.hourlyTotalForThisMonth(contact!)
        thisMonthVolunteering.text = shopUseLog.hourlyVolunteerTotalForThisMonth(contact!)
        lastMonthShopUse.text = shopUseLog.hourlyTotalForLastMonth(contact!)
        lastMonthVolunteering.text = shopUseLog.hourlyVolunteerTotalForLastMonth(contact!)
        if self.tabBarController?.selectedIndex == 0 {
            self.navigationItem.rightBarButtonItem = nil 
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit User Segue" {
            let vc = segue.destinationViewController as! EditUserViewController
            vc.contact = contact
        }
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

