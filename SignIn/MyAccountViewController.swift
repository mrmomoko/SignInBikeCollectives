//
//  MyAccountViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 9/30/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class MyAccountViewController : UITableViewController, SaferSpaceViewControllerDelegate, WaiverViewControllerDelegate, TypesViewControllerDelegate, MemberTypeViewControllerDelegate, PasswordViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    let org = OrganizationLog().organizationLog.first
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var defaultSignOut: UITextField!
    @IBOutlet weak var saferSpaceText: UILabel!
    @IBOutlet weak var waiverText: UILabel!
    @IBOutlet weak var yesOrNoQuestion: UITextField!

    func sendData() {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["analyst@bikefarm.org"])
        mailComposeViewController.setSubject("Organization Data")
        mailComposeViewController.setMessageBody(OrganizationLog().orgData(), isHTML: false)
        navigationController?.presentViewController(mailComposeViewController, animated: true) {
        }
    }
    
    // mailComposeDelegateMethods
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        let rightBarButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "showSaveAlert")
        let uploadButton = UIBarButtonItem(image: UIImage(named: "cloud"), style: .Plain, target: self, action: "sendData")
        uploadButton.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        self.navigationItem.rightBarButtonItems = [rightBarButton, uploadButton]
        
        name.text = org!.name
        emailAddress.text = org!.emailAddress
        zipCode.text = org!.zipCode
        defaultSignOut.text = String((org!.defaultSignOutTime)!)
        yesOrNoQuestion.text = org!.yesOrNoQuestion
        saferSpaceText.text = org?.saferSpaceAgreement
        waiverText.text = org?.waiver

     }
    
    override func viewDidAppear(animated: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueIdentifier = segue.identifier
        
        if segueIdentifier == "Safer Space Segue" {
            let vc = segue.destinationViewController as! SaferSpaceViewController
            vc.delegate = self
            vc.org = org
        }
        if segueIdentifier == "Waiver Segue" {
            let vc = segue.destinationViewController as! WaiverViewController
            vc.delegate = self
            vc.org = org
        }
        if segueIdentifier == "Types Segue" {
            let vc = segue.destinationViewController as! TypesViewController
            vc.delegate = self
            vc.org = org
        }
        if segueIdentifier == "Members Segue" {
            let vc = segue.destinationViewController as! MemberTypeViewController
            vc.delegate = self
            vc.org = org
        }
        if segueIdentifier == "Password Segue" {
            let vc = segue.destinationViewController as! PasswordViewController
            vc.delegate = self
            vc.org = org
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showSaveAlert() {
        org!.name = name.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        org!.emailAddress = emailAddress.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        org!.zipCode = zipCode.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        org!.defaultSignOutTime = Int(defaultSignOut.text!)
        org!.yesOrNoQuestion = yesOrNoQuestion.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        OrganizationLog().saveOrg(org!)
    }
    
    // safer space delegate
    func didAddSaferSpaceAggrement(sender:SaferSpaceViewController) {
        self.navigationController?.popViewControllerAnimated(true)
        saferSpaceText.text = org?.saferSpaceAgreement
    }

    func didAddWaiver(sender: WaiverViewController) {
        self.navigationController?.popViewControllerAnimated(true)
        waiverText.text = org?.waiver
    }
    
    func didSaveType(sender: TypesViewController) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didSaveMemberType(sender: MemberTypeViewController) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didAddPassword(sender: PasswordViewController) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
