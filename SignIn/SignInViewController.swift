//
//  SignInViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/1/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class SignInViewController: UIViewController, UITableViewDataSource {

    let contactLog = ContactLog()
    var currentContact : Contact!
    var newSignUpName = ""
    var filteredLog: [Contact]
    
    @IBOutlet weak var uniqueIdentifier: UITextField!
    
    @IBOutlet weak var mostRecentSignIns: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        filteredLog = contactLog.allContacts
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        filteredLog = contactLog.recentContactsWhoAreNotLoggedIn()
        if filteredLog.count == 0 {
            filteredLog = contactLog.allContacts
        }
        mostRecentSignIns.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "New User Segue" {
            let vc = segue.destinationViewController as! NewUserViewController
            vc.contactIndentifier = uniqueIdentifier.text
        }
        if segue.identifier == "Thank You" {
            let vc = segue.destinationViewController as! BFFThankYouForSigningIn
            vc.contact = currentContact
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLog.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! ContactTableViewCell
        
        if indexPath.row == 0 {
            cell.titleLabel!.text = "I'm New, I don't have a login"
            cell.titleLabel!.textAlignment = .Center
            cell.detailLabel!.text = ""
            // I'd like to formate this cell to look more like a button, or maybe I should put a button in it?
        } else {
            let contact = filteredLog[indexPath.row - 1]
            let membership = contact.valueForKey("membership") as? Membership
            var title = contact.valueForKey("firstName") as? String
            if title == "" {
                title = contact.valueForKey("lastName") as? String
            }
            let membershipType = membership?.membershipType
            cell.titleLabel.text = title
            cell.detailLabel.text = membershipType
            let circle = UIImage(named: "circle")
            cell.circleView.image = circle
            cell.circleView.tintColor = contactLog.colourOfContact(contact)
    }
        return cell
    }
    
    func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            newSignUpName = uniqueIdentifier.text
            performSegueWithIdentifier("New User Segue", sender: self)
        } else {
            currentContact = filteredLog[indexPath.row - 1]
            performSegueWithIdentifier("Thank You", sender: self)
        }
    }
    
    func textField( textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
//        if count(uniqueIdentifier.text) == 1 && string == "" {
//            filteredLog = contactLog.recentUsersWhoAreNotLoggedIn
//        } else {
            _searchContactsWithSubstring(string)
 //       }
        return true
    }
    
    
    func _searchContactsWithSubstring(substring: String) {
        let prefix = uniqueIdentifier.text.lowercaseString
        var fullContactList = contactLog.allContacts
        let predicate = NSPredicate(format: "firstName BEGINSWITH %@ OR lastName BEGINSWITH %@ OR pin BEGINSWITH %@ OR emailAddress BEGINSWITH %@", prefix, prefix, prefix, prefix)
//        let predicate = NSPredicate(format:"firstName BEGINSWITH %@", prefix)
        
        filteredLog = (fullContactList as NSArray).filteredArrayUsingPredicate(predicate) as! [Contact]
        if filteredLog == [] {filteredLog = fullContactList}
        mostRecentSignIns.reloadData()
    }
}
