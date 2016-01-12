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
    let orgLog = OrganizationLog()
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pin: UITextField!
    @IBOutlet weak var permissionToEmail: UISwitch!
    @IBOutlet weak var yesNoQuestion: UILabel!
    
    @IBAction func save(sender: AnyObject) {
        if firstName.text == "" && lastName.text == "" && email.text == "" {
            showAlertForIncompleteForm()
        } else {
        // set the contacts properties
        contact!.firstName = firstName.text!
        contact!.lastName = lastName.text!
        contact!.emailAddress = email.text!
        contact!.pin = pin.text!
        contact!.yesOrNoQuestion = permissionToEmail.on

        // save contact
        contactLog.saveContact(contact!)
        
        // show waiver
        showWaiverForCompleteForm()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contact = contactLog.createUserWithIdentity(contactIndentifier!)
        firstName.text = contact!.firstName
        let yesNo = orgLog.currentOrganization().organization?.yesOrNoQuestion
        yesNoQuestion.text = yesNo
        if yesNo == "" {
            yesNoQuestion.hidden = true
            permissionToEmail.hidden = true
        }
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    override func viewDidAppear(animated: Bool) {
        firstName.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if firstName.text == "" && lastName.text == "" && email.text == "" {
            //delete the contact from the data base
            contactLog.deleteContact(contact!)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Thank You" {
            let vc = segue.destinationViewController as! BFFThankYouForSigningIn
            vc.contact = contact!
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CircleCollectionViewCell
        let image = UIImage(named: "circle")
        cell.circleImage.image = image
        
        if indexPath.row == 0 {
            cell.circleImage.tintColor = UIColor.purpleColor()
        }
        else if indexPath.row == 1 {
            cell.circleImage.tintColor = UIColor.cyanColor()
        }
        else if indexPath.row == 2 {
            cell.circleImage.tintColor = UIColor.greenColor()
        }
        else if indexPath.row == 3 {
            cell.circleImage.tintColor = UIColor.yellowColor()
        }
        else if indexPath.row == 4 {
            cell.circleImage.tintColor = UIColor.orangeColor()
        }
        else if indexPath.row == 5 {
            cell.circleImage.tintColor = UIColor.redColor()
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
            collectionView.backgroundColor = UIColor(red:0.00, green:0.87, blue:0.9, alpha:1)
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
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showAlertForIncompleteForm() {
        let alert = UIAlertController(title: "Did you mean to save", message: "You need to fill in at least one field to create a user", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showWaiverForCompleteForm () {
        if let waiver = orgLog.currentOrganization().organization!.waiver {
            if waiver == "" {
                performSegueWithIdentifier("Thank You", sender: self)
            } else {
                let alert = UIAlertController(title: "Waiver", message: waiver, preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alert.addAction(cancel)
                let agree = UIAlertAction(title: "I Agree", style: .Default, handler: { alert in self.performSegueWithIdentifier("Thank You", sender: self)
                })
                alert.addAction(agree)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}
