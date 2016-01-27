//
//  SignInViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/1/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class SignInViewController: UIViewController, UITableViewDataSource, UITabBarControllerDelegate {

    let contactLog = ContactLog()
    var currentContact : Contact!
    var newSignUpName = ""
    var filteredLog: [Contact]
    let orgLog = OrganizationLog()
    
    @IBOutlet weak var uniqueIdentifier: UITextField!
    @IBOutlet weak var mostRecentSignIns: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        filteredLog = contactLog.allContacts
        super.init(coder: aDecoder)
        self.tabBarController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //refresh all contact data, some memberships may have expired. 
        contactLog.refreshContactMembershipData()
    }
    
    override func viewDidAppear(animated: Bool) {
        uniqueIdentifier.text = ""
        filteredLog = usersWhoAreNotLoggedIn()
        mostRecentSignIns.reloadData()
        self.title = OrganizationLog().currentOrganization().organization?.name
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
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! NewUserButtonCell
            cell.buttonView.backgroundColor = Colors().blue
            cell.buttonView.layer.cornerRadius = 10.0
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! ContactTableViewCell
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
            return cell
        }
    }
    
    func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            newSignUpName = uniqueIdentifier.text!
            performSegueWithIdentifier("New User Segue", sender: self)
        } else {
            currentContact = filteredLog[indexPath.row - 1]
            if currentContact.hasGoneThroughSetUp == false {
                showSaferSpaceAgreement()
            } else {
                performSegueWithIdentifier("Thank You", sender: self)
            }
        }
    }
    
    func textField( textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if uniqueIdentifier.text?.characters.count == 1 && string == "" {
            filteredLog = contactLog.recentContactsWhoAreNotLoggedIn()
            mostRecentSignIns.reloadData()
        }
        else {
            let combinedString = (uniqueIdentifier.text! + string)
            _searchContactsWithSubstring(combinedString)
        }
        return true
    }
    
    func _searchContactsWithSubstring(substring: String) {
        let fullContactList = ContactLog().recentContactsWhoAreNotLoggedIn()
        let predicate = NSPredicate(format: "firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@ OR pin BEGINSWITH[cd] %@ OR emailAddress BEGINSWITH[cd] %@", substring, substring, substring, substring)
        filteredLog = (fullContactList as NSArray).filteredArrayUsingPredicate(predicate) as! [Contact]
        if filteredLog == [] {filteredLog = fullContactList}
        mostRecentSignIns.reloadData()
    }
    
    func usersWhoAreNotLoggedIn() -> [Contact] {
        var loggedInUsers = [Contact]()
        for contact in ContactLog().allContacts {
            if contact.recentUse!.timeIntervalSinceNow < 0 {
                loggedInUsers.append(contact)
            }
        }
        return loggedInUsers
    }
    
    func showSaferSpaceAgreement() {
        if let saferSpace  = orgLog.currentOrganization().organization!.saferSpaceAgreement  {
            if saferSpace == ""  {
                performSegueWithIdentifier("Thank You", sender: self)
            } else {
                let alert = UIAlertController(title: "SaferSpace", message: saferSpace, preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alert.addAction(cancel)
                let agree = UIAlertAction(title: "I Agree", style: .Default, handler: { alert in self.performSegueWithIdentifier("Thank You", sender: self)
                    self.currentContact.hasGoneThroughSetUp = true
                })
                alert.addAction(agree)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}
