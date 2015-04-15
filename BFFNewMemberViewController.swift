//
//  BFFNewMemberViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/27/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class BFFNewMemberViewController: UIViewController, UITableViewDelegate {

    var contact = BCNContact()

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pin: UITextField!
    @IBOutlet weak var emailPermission: UISwitch!
    
    @IBOutlet weak var membershipTableView: UITableView!
    @IBOutlet weak var colourTableView: UITableView!

    @IBAction func save(sender: AnyObject) {
        // create a contact
        contact.firstName = firstName.text
        contact.lastName = lastName.text
        contact.emailAddress = email.text
        contact.pin = pin.text
        contact.okToContact = emailPermission.on

        // then save it
        var contactLog = BCNContactLog.sharedStore()
        contactLog.saveContact(contact)
        //create a membership
        // or do I need to? membership is on the contact.
        // i need a method that is "isMembershipActive"
        
        // dismiss view controller
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}

extension BFFNewMemberViewController {
    // why do I override?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Mark: - TableView Delegate -
extension BFFNewMemberViewController {
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // Return the count of the number of rows in the table
        var number = Int()
        if tableView == membershipTableView{
        number = 4
        }
        if tableView == colourTableView {
        number = 6
        }
        return number
    }
    
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            var cell = UITableViewCell()
            if tableView == membershipTableView {
                if indexPath.row == 0 {
                    cell = membershipTableView.dequeueReusableCellWithIdentifier("month") as! UITableViewCell
                    cell.textLabel?.text = "1 Month"
                }
                else if indexPath.row == 1 {
                    cell = membershipTableView.dequeueReusableCellWithIdentifier("6 month") as! UITableViewCell
                    cell.textLabel?.text = "6 Month"
                }
                else if indexPath.row == 2 {
                    cell = membershipTableView.dequeueReusableCellWithIdentifier("year") as! UITableViewCell
                    cell.textLabel?.text = "1 Year"
                }
                else {
                    cell = membershipTableView.dequeueReusableCellWithIdentifier("life") as! UITableViewCell
                    cell.textLabel?.text = "Bike Farm for Life"
                }
            }
            if tableView == colourTableView {
                if indexPath.row == 0 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Purple Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.purpleColor()
                }
                else if indexPath.row == 1 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Blue Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.cyanColor()
                }
                else if indexPath.row == 2 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Green Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.greenColor()
                }
                else if indexPath.row == 3 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Yellow Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.yellowColor()
                }
                else if indexPath.row == 4 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Orange Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.orangeColor()
                }
                else if indexPath.row == 5 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Red Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.redColor()
                }
            }
       return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedMembership = BCNMembershipType.TypeNonMember
        if tableView == membershipTableView {
            if indexPath.row == 0 {
                selectedMembership = BCNMembershipType.TypeMonthly
            }
            else if indexPath.row == 1 {
                selectedMembership = BCNMembershipType.Type6Month
            }
            else if indexPath.row == 2 {
                selectedMembership = BCNMembershipType.TypeYearly
            }
            else if indexPath.row == 3 {
                selectedMembership = BCNMembershipType.TypeLifeTime
            }
            self.contact.membershipType = selectedMembership
        }
        if tableView == colourTableView {
            if indexPath.row == 0 {
                contact.colour = UIColor.purpleColor()
                view.backgroundColor = UIColor.purpleColor()
            }
            else if indexPath.row == 1 {
                contact.colour = UIColor.cyanColor()
                view.backgroundColor = UIColor.cyanColor()
            }
            else if indexPath.row == 2 {
                contact.colour = UIColor.greenColor()
                view.backgroundColor = UIColor.greenColor()
            }
            else if indexPath.row == 3 {
                contact.colour = UIColor.yellowColor()
                view.backgroundColor = UIColor.yellowColor()
            }
            else if indexPath.row == 4 {
                contact.colour = UIColor.orangeColor()
                view.backgroundColor = UIColor.orangeColor()
            }
            else if indexPath.row == 5 {
                contact.colour = UIColor.redColor()
                view.backgroundColor = UIColor.redColor()
             
            }
        }
    }
}

