//
//  MyAccountViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 9/30/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class MyAccountViewController : UIViewController {
    
    @IBAction func sendData(sender: AnyObject) {
        let activityItems = [ContactLog().returnAllContactsAsCommaSeporatedString()]
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
        let alert = UIAlertController(title: "Password", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler: nil))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter Password:"
            textField.secureTextEntry = false
        })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
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
    //

    
}
