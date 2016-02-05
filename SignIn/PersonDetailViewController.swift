//
//  BFFPersonDetailViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/29/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

protocol PersonDetailViewControllerDelegate {
    func didMakeChangesToContactOnEditVC()
}

class PersonDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditUserViewControllerDelegate {
   
    var contact : Contact?
    var shopUse : ShopUse?
    let shopUseLog = ShopUseLog()
    var typesOfUsers = [String]()
    var delegate : PersonDetailViewControllerDelegate? = nil
    
    @IBOutlet weak var firstNameLastInitial: UILabel!
    @IBOutlet weak var hoursTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissViewControllerAfterTimeOut()
        firstNameLastInitial.text = contact?.displayName()
        // user interface for employees
        if self.tabBarController?.selectedIndex == 0 {
            self.navigationItem.rightBarButtonItem = nil 
        }
        typesOfUsers = ContactLog().typesUsedByContact(contact!)
    }
    override func viewDidAppear(animated: Bool) {
         typesOfUsers = ContactLog().typesUsedByContact(contact!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit User Segue" {
            let vc = segue.destinationViewController as! EditUserViewController
            vc.contact = contact
            vc.delegate = self
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            let membershipExpiration = contact?.membership!.membershipExpiration
            cell.textLabel?.text = contact?.membership!.membershipType
            if membershipExpiration?.timeIntervalSinceNow > 0 {
                cell.detailTextLabel?.text = String("Expires " + dateFormatter.stringFromDate(membershipExpiration!))
            } else {
                cell.textLabel?.text = "Membership does not exist or is expired"
                cell.detailTextLabel?.text = ""
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("HourShopUseCell") as! HourShopUseCell
            let typeTitle = typesOfUsers[indexPath.row]
            cell.title!.text = typeTitle
            let shopUseLog = ShopUseLog()
            let hourThisMonth = shopUseLog.hourlyTotalForThisMonth(contact!, typeTitle: typeTitle)
            let totalHours = shopUseLog.numberOfHoursLoggedByContact(contact!, typeTitle: typeTitle)
            let lastMonthTotal = shopUseLog.hourlyTotalForLastMonth(contact!, typeTitle: typeTitle)
            if hourThisMonth == "1" {
                cell.detailHours.text = "1 hour this month"
                cell.totalHours.text = "1 hour"
                cell.lastMonth.text = "1 hour last month"
            } else {
                cell.detailHours.text = hourThisMonth + " hours this month"
                cell.totalHours.text = totalHours + " hours"
                cell.lastMonth.text = lastMonthTotal + " hours last month"
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return typesOfUsers.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Membership"
        } else {
            return "Hours of Shop Use"
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 40
        } else {
            return 60
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func didMakeChangesToContact() {
        self.navigationController?.popViewControllerAnimated(true)
        self.hoursTableView.reloadData()
        firstNameLastInitial.text = contact?.firstName
        delegate!.didMakeChangesToContactOnEditVC()
    }
    
}

