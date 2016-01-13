//
//  MyAccountViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 9/30/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class MyAccountViewController : UITableViewController, SaferSpaceViewControllerDelegate, WaiverViewControllerDelegate, TypesViewControllerDelegate {
    
    let org = OrganizationLog().organizationLog.first
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var saferSpaceText: UILabel!
    @IBOutlet weak var waiverText: UILabel!
    @IBOutlet weak var yesOrNoQuestion: UITextField!

    func sendData(sender: AnyObject) {
        let activityItems = OrganizationLog().orgData()
        let activityViewController = UIActivityViewController(activityItems: activityItems as [AnyObject], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePrint, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypeAddToReadingList]
        presentViewController(activityViewController, animated: true, completion: nil)
        
        // Define completion handler
        
        activityViewController.completionWithItemsHandler = {activity, success, items, error in
            if !success {
                return
            }
        }
    }
    
    override func viewDidLoad() {
        let rightBarButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "showSaveAlert")
        let uploadButton = UIBarButtonItem(image: UIImage(named: "cloud"), style: .Plain, target: self, action: "")
        uploadButton.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        self.navigationItem.rightBarButtonItems = [rightBarButton, uploadButton]
     }
    
    override func viewDidAppear(animated: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        name.text = org!.name
        emailAddress.text = org!.emailAddress
        password.text = org!.password
        yesOrNoQuestion.text = org!.yesOrNoQuestion
        saferSpaceText.text = org?.saferSpaceAgreement
        waiverText.text = org?.waiver
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
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showSaveAlert() {
        org!.name = name.text
        org!.emailAddress = emailAddress.text
        org!.password = password.text
        org!.yesOrNoQuestion = yesOrNoQuestion.text

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
    
    // tableview methods
    
    //- (NSString *)commaSeporatedStyle;
    //{
    //    NSString *contactString = @"";
    //    NSString *commaSeporatedString = @"First name, Last name, Email,\n";
    //    for (BCNContact *contact in self.contactLog) {
    //        contactString = [NSString stringWithFormat:@"%@, %@, %@,\n", contact.firstName, contact.lastName, contact.emailAddress];
    //        commaSeporatedString = [commaSeporatedString stringByAppendingString:contactString];
    //    }
    //
    //    return commaSeporatedString;
    //}
}
