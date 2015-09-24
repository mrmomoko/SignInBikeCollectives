//
//  NewUserViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/8/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class NewUserViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var contact : Contact?
    var contactIndentifier : String?
    let contactLog = ContactLog()
    let shopUseLog = ShopUseLog()
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pin: UITextField!
    
    @IBOutlet weak var permissionToEmail: UISwitch!

    @IBOutlet weak var colourCollectionView: UICollectionView!
    
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
        
        // show waiver
        showWaiverForCompleteForm()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        contact = contactLog.createUserWithIdentity(contactIndentifier!)

        showAlertForCompleteForm()

        firstName.text = contact!.firstName
        lastName.text = contact!.lastName
        email.text = contact!.emailAddress
        colourCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    override func viewWillDisappear(animated: Bool) {
        if firstName.text == "" && lastName.text == "" && email.text == "" {
            //delete the contact from the data base
            contactLog.deleteContact(contact!)
        } else {
            ContactLog()
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Thank You" {
            let vc = segue.destinationViewController as! BFFThankYouForSigningIn
            vc.contact = contact!
            vc.weHaventAlreadyAsed = false
        }
    }
}

// Mark: - CollectionView Delegate -

extension NewUserViewController {

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
        }
        else if indexPath.row == 1 {
            contactLog.editColourForContact(contact!, colour: .blue)
            view.backgroundColor = UIColor.cyanColor()
            collectionView.backgroundColor = UIColor.cyanColor()
        }
        else if indexPath.row == 2 {
            contactLog.editColourForContact(contact!, colour: .green)
            view.backgroundColor = UIColor.greenColor()
            collectionView.backgroundColor = UIColor.greenColor()
        }
        else if indexPath.row == 3 {
            contactLog.editColourForContact(contact!, colour: .yellow)
            view.backgroundColor = UIColor.yellowColor()
            collectionView.backgroundColor = UIColor.yellowColor()
        }
        else if indexPath.row == 4 {
            contactLog.editColourForContact(contact!, colour: .orange)
            view.backgroundColor = UIColor.orangeColor()
            collectionView.backgroundColor = UIColor.orangeColor()
        }
        else if indexPath.row == 5 {
            contactLog.editColourForContact(contact!, colour: .red)
            view.backgroundColor = UIColor.redColor()
            collectionView.backgroundColor = UIColor.redColor()
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
        let agree = UIAlertAction(title: "I Agree", style: .Default, handler: { alert in self.performSegueWithIdentifier("Thank You", sender: self)})
        alert.addAction(agree)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertForCompleteForm () {
        let alert = UIAlertController(title: "Are you here to work on your bike or volunteer", message: nil, preferredStyle: .Alert)
        let shopUse = UIAlertAction(title: "Use the Shop", style: .Default, handler: { alert in self.shopUseLog.createShopUseWithContact(self.contact!)
        })
        alert.addAction(shopUse)
        let volunteer = UIAlertAction(title: "Volunteer", style: .Default, handler: { alert in self.shopUseLog.createVolunteerUseWithContact(self.contact!)
        })
        alert.addAction(volunteer)
        let undo = UIAlertAction(title: "Undo", style: .Default, handler: {alert in
            self.contactLog.deleteContact(self.contact!)
        })
        alert.addAction(undo)
        presentViewController(alert, animated: true, completion: nil)
    }

}
