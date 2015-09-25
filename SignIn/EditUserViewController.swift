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
            contact!.firstName = firstName.text!
            contact!.lastName = lastName.text!
            contact!.emailAddress = email.text!
            contact!.pin = pin.text!
            
            // save contact
            contactLog.saveContact(contact!)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor.purpleColor()
        }
        else if indexPath.row == 1 {
            cell.backgroundColor = UIColor.cyanColor()
        }
        else if indexPath.row == 2 {
            cell.backgroundColor = UIColor.greenColor()
        }
        else if indexPath.row == 3 {
            cell.backgroundColor = UIColor.yellowColor()
        }
        else if indexPath.row == 4 {
            cell.backgroundColor = UIColor.orangeColor()
        }
        else if indexPath.row == 5 {
            cell.backgroundColor = UIColor.redColor()
        }
        return cell
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
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?
            if indexPath.row == 0 {
                cell!.textLabel?.text = "Non Member"
            }
            else if indexPath.row == 1 {
                cell!.textLabel?.text = "One Month"
            }
            else if indexPath.row == 2 {
                cell!.textLabel?.text = "Six Months"
            }
            else if indexPath.row == 3 {
                cell!.textLabel?.text = "Yearly"
            }
            else if indexPath.row == 4 {
                cell!.textLabel?.text = "Life Time"
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
}
