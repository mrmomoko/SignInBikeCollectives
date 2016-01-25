//
//  EditUserViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 8/13/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

protocol EditUserViewControllerDelegate {
    func didMakeChangesToContact()
}

class EditUserViewController: UIViewController, UITableViewDelegate {
    
    var contact : Contact?
    let contactLog = ContactLog()
    let membershipLog = MembershipLog()
    var delegate : EditUserViewControllerDelegate? = nil
    var types = [String]()
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pin: UITextField!
    @IBOutlet weak var yesOrNoQuestion: UILabel!
    @IBOutlet weak var yesOrNoSwitch: UISwitch!
    
    @IBOutlet weak var membershipTableView: UITableView!

    @IBAction func save(sender: AnyObject) {
        if firstName.text == "" && lastName.text == "" && email.text == "" {
            showAlertForIncompleteForm()
        } else {
            // set the contacts properties
            contact!.firstName = firstName.text!
            contact!.lastName = lastName.text!
            contact!.emailAddress = email.text!
            contact!.yesOrNoQuestion = yesOrNoSwitch.on
            contact!.pin = pin.text!
            
            // save contact
            contactLog.saveContact(contact!)
            delegate!.didMakeChangesToContact()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesOrNoSwitch.tintColor = Colors().blue
        yesOrNoSwitch.onTintColor = Colors().blue
        if let contact = contact {
            firstName.text = contact.firstName
            lastName.text = contact.lastName
            email.text = contact.emailAddress
            yesOrNoQuestion.text = OrganizationLog().organizationLog.first?.yesOrNoQuestion
            if yesOrNoQuestion.text == ""{
                yesOrNoSwitch.hidden = true
            } else {
                yesOrNoSwitch.on = (contact.yesOrNoQuestion?.boolValue)!
            }
        } else {
            contact = contactLog.createUserWithIdentity("edit user")
        }
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CircleCollectionViewCell
        let image = UIImage(named: "circle")
        cell.circleImage.image = image
        
        if indexPath.row == 0 {
            cell.circleImage.tintColor = Colors().purple
        }
        else if indexPath.row == 1 {
            cell.circleImage.tintColor = Colors().blue
        }
        else if indexPath.row == 2 {
            cell.circleImage.tintColor = Colors().green
        }
        else if indexPath.row == 3 {
            cell.circleImage.tintColor = Colors().yellow
        }
        else if indexPath.row == 4 {
            cell.circleImage.tintColor = Colors().orange
        }
        else if indexPath.row == 5 {
            cell.circleImage.tintColor = Colors().red
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            contactLog.editColourForContact(contact!, colour: .purple)
            collectionView.backgroundColor = Colors().purpleHighlight
        }
        else if indexPath.row == 1 {
            contactLog.editColourForContact(contact!, colour: .blue)
            collectionView.backgroundColor = Colors().blueHighlight
        }
        else if indexPath.row == 2 {
            contactLog.editColourForContact(contact!, colour: .green)
            collectionView.backgroundColor = Colors().greenHighlight
        }
        else if indexPath.row == 3 {
            contactLog.editColourForContact(contact!, colour: .yellow)
            collectionView.backgroundColor = Colors().yellowHighlight
        }
        else if indexPath.row == 4 {
            contactLog.editColourForContact(contact!, colour: .orange)
            collectionView.backgroundColor = Colors().orangeHighlight
        }
        else if indexPath.row == 5 {
            contactLog.editColourForContact(contact!, colour: .red)
            collectionView.backgroundColor = Colors().redHighlight
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        let org = OrganizationLog()
        types = org.activeMembershipTypes()
        return types.count
    }
    
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?
            cell?.textLabel?.text = types[indexPath.row]
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        membershipLog.editMembershipTypeForContact(contact!, type: types[indexPath.row])
    }
    
    func showAlertForIncompleteForm() {
        let alert = UIAlertController(title: "Did you mean to save", message: "You need to fill in at least one field to create a user", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
}
