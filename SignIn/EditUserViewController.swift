//
//  EditUserViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 8/13/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class EditUserViewController: UIViewController, UITableViewDelegate {
    
    var contact : Contact?
    let contactLog = ContactLog()
    let membershipLog = MembershipLog()
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pin: UITextField!
    
    @IBOutlet weak var colourCollectionView: UICollectionView!
    @IBOutlet weak var membershipTableView: UITableView!

    @IBAction func save(sender: AnyObject) {
        if firstName.text == "" && lastName.text == "" && email.text == "" {
            showAlertForIncompleteForm()
        } else {
            // set the contacts properties
            contact!.firstName = firstName.text
            contact!.lastName = lastName.text
            contact!.emailAddress = email.text
            contact!.pin = pin.text
            
            // save contact
            contactLog.saveContact(contact!)

            // show waiver
            showWaiverForCompleteForm()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contact = contact {
            firstName.text = contact.firstName
            lastName.text = contact.lastName
            email.text = contact.emailAddress
        } else {
            contact = contactLog.createUserWithIdentity("edit user")
        }
        colourCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    override func viewWillDisappear(animated: Bool) {
        if firstName.text == "edit user" && lastName.text == "" && email.text == "" {
            //delete the contact from the data base
            contactLog.deleteContact(contact!)
        }
    }
}

// Mark: - TableView Delegate -
extension EditUserViewController {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? UICollectionViewCell
        if indexPath.row == 0 {
            cell!.backgroundColor = UIColor.purpleColor()
        }
        else if indexPath.row == 1 {
            cell!.backgroundColor = UIColor.cyanColor()
        }
        else if indexPath.row == 2 {
            cell!.backgroundColor = UIColor.greenColor()
        }
        else if indexPath.row == 3 {
            cell!.backgroundColor = UIColor.yellowColor()
        }
        else if indexPath.row == 4 {
            cell!.backgroundColor = UIColor.orangeColor()
        }
        else if indexPath.row == 5 {
            cell!.backgroundColor = UIColor.redColor()
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            contactLog.editColourForContact(contact!, colour: .purple)
            view.backgroundColor = UIColor.purpleColor()
            collectionView.backgroundColor = UIColor.purpleColor()
            membershipTableView.backgroundColor = UIColor.purpleColor()
        }
        else if indexPath.row == 1 {
            contactLog.editColourForContact(contact!, colour: .blue)
            view.backgroundColor = UIColor.cyanColor()
            collectionView.backgroundColor = UIColor.cyanColor()
            membershipTableView.backgroundColor = UIColor.cyanColor()
        }
        else if indexPath.row == 2 {
            contactLog.editColourForContact(contact!, colour: .green)
            view.backgroundColor = UIColor.greenColor()
            collectionView.backgroundColor = UIColor.greenColor()
            membershipTableView.backgroundColor = UIColor.greenColor()
        }
        else if indexPath.row == 3 {
            contactLog.editColourForContact(contact!, colour: .yellow)
            view.backgroundColor = UIColor.yellowColor()
            collectionView.backgroundColor = UIColor.yellowColor()
            membershipTableView.backgroundColor = UIColor.yellowColor()
        }
        else if indexPath.row == 4 {
            contactLog.editColourForContact(contact!, colour: .orange)
            view.backgroundColor = UIColor.orangeColor()
            collectionView.backgroundColor = UIColor.orangeColor()
            membershipTableView.backgroundColor = UIColor.orangeColor()
        }
        else if indexPath.row == 5 {
            contactLog.editColourForContact(contact!, colour: .red)
            view.backgroundColor = UIColor.redColor()
            collectionView.backgroundColor = UIColor.redColor()
            membershipTableView.backgroundColor = UIColor.redColor()
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
            if indexPath.row == 0 {
                cell.textLabel?.text = "Non Member"
            }
            else if indexPath.row == 1 {
                cell.textLabel?.text = "One Month"
            }
            else if indexPath.row == 2 {
                cell.textLabel?.text = "Six Months"
            }
            else if indexPath.row == 3 {
                cell.textLabel?.text = "Yearly"
            }
            else if indexPath.row == 4 {
                cell.textLabel?.text = "Life Time"
            }
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            membershipLog.editMembershipTypeForContact(contact!, type: "Non Member")
        }
        else if indexPath.row == 1 {
            membershipLog.editMembershipTypeForContact(contact!, type: "One Month")
        }
        else if indexPath.row == 2 {
            membershipLog.editMembershipTypeForContact(contact!, type: "Six Months")
        }
        else if indexPath.row == 3 {
            membershipLog.editMembershipTypeForContact(contact!, type: "Yearly")
        }
        else if indexPath.row == 4 {
            membershipLog.editMembershipTypeForContact(contact!, type: "Life Time")
        }

    }
    
    func showAlertForIncompleteForm() {
        let alert = UIAlertController(title: "Did you mean to save", message: "You need to fill in at least one field to create a user", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showWaiverForCompleteForm () {
        let alert = UIAlertController(title: "Waiver - You're working on your bike - Please don't sue us", message: " I, and my heirs, in consideration of my participation in Bike Farm Inc., hereby release Bike Farm Inc., its officers, employees and agents, and any other people officially connected with this event, from any and all liability for damage to or loss of personal property, sickness or injury from whatever source, legal entanglements, imprisonment, death, or loss of money, which might occur while participating in this event. Specifically, I release said persons from any liability or responsibility for injury while working on my bike and other accidents relating to riding this bicycle. I am aware of the risks of participation, which include, but are not limited to, the possibility of sprained muscles and ligaments, broken bones and fatigue. I hereby state that I am in sufficient physical condition to accept a rigorous level of physical activity. I understand that participation in this program is strictly voluntary and I freely chose to participate. I understand that Bike Farm does not provide medical coverage for me. I verify that I will be responsible for any medical costs I incur as a result of my participation.", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        let agree = UIAlertAction(title: "I Agree", style: .Default, handler: { alert in self.dismissViewControllerAnimated(true, completion: nil)})
        alert.addAction(agree)
        presentViewController(alert, animated: true, completion: nil)
    }
}
