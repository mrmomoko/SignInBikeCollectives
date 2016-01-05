//
//  BFFPersonDetailViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/29/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class PersonDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditUserViewControllerDelegate {
   
    var contact : Contact?
    var shopUse : ShopUse?
    let shopUseLog = ShopUseLog()
    var typesOfUsers = [String]()
    
    @IBOutlet weak var firstNameLastInitial: UILabel!
    @IBOutlet weak var hoursTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissViewControllerAfterTimeOut()
        firstNameLastInitial.text = contact?.firstName
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        if indexPath.row == 0 {
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
        } else if indexPath.row > 0 {
            let typeTitle = typesOfUsers[indexPath.row - 1]
            cell.textLabel?.text = typeTitle
            // get hours of use for each type
            cell.detailTextLabel?.text = ShopUseLog().hourlyTotalForThisMonth(contact!, typeTitle: typeTitle) + " hours of use this month"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typesOfUsers.count + 1
    }
    
//    func table
    
    func didMakeChangesToContact() {
        self.navigationController?.popViewControllerAnimated(true)
        self.hoursTableView.reloadData()
    }
    
}

