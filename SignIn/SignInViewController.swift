//
//  SignInViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/1/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class SignInViewController: UIViewController, UITableViewDataSource, UITabBarControllerDelegate, BFFThankYouForSigningInDelegate {

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
    
    override func viewDidAppear(_ animated: Bool) {
        uniqueIdentifier.text = ""
        filteredLog = usersWhoAreNotLoggedIn()
        mostRecentSignIns.reloadData()
        self.title = OrganizationLog().currentOrganization().organization?.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "New User Segue" {
            let vc = segue.destination as! NewUserViewController
            vc.contactIndentifier = uniqueIdentifier.text
        }
        if segue.identifier == "Thank You" {
            let vc = segue.destination as! BFFThankYouForSigningIn
            vc.contact = currentContact
            vc.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLog.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! NewUserButtonCell
            cell.buttonView.backgroundColor = Colors().blue
            cell.buttonView.layer.cornerRadius = 10.0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! ContactTableViewCell
            let contact = filteredLog[indexPath.row - 1]
            let membership = contact.value(forKey: "membership") as? Membership
            var title = contact.displayName()
            if contact.firstName == "" {
                title = (contact.value(forKey: "lastName") as? String)!
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
    
    func tableView( _ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if indexPath.row == 0 {
            newSignUpName = uniqueIdentifier.text!
            performSegue(withIdentifier: "New User Segue", sender: self)
        } else {
            currentContact = filteredLog[indexPath.row - 1]
            if currentContact.hasGoneThroughSetUp == false {
                showSaferSpaceAgreement()
            } else {
                performSegue(withIdentifier: "Thank You", sender: self)
            }
        }
    }
    
    func textField( _ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if uniqueIdentifier.text?.count == 1 && string == "" {
            filteredLog = contactLog.recentContactsWhoAreNotLoggedIn()
            mostRecentSignIns.reloadData()
        }
        else {
            let combinedString = (uniqueIdentifier.text! + string)
            _searchContactsWithSubstring(combinedString)
        }
        return true
    }
    
    func _searchContactsWithSubstring(_ substring: String) {
        let fullContactList = ContactLog().recentContactsWhoAreNotLoggedIn()
        let predicate = NSPredicate(format: "firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@ OR pin BEGINSWITH[cd] %@ OR emailAddress BEGINSWITH[cd] %@", substring, substring, substring, substring)
        filteredLog = (fullContactList as NSArray).filtered(using: predicate) as! [Contact]
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
                performSegue(withIdentifier: "Thank You", sender: self)
            } else {
                let alert = UIAlertController(title: "SaferSpace", message: saferSpace, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                let agree = UIAlertAction(title: "I Agree", style: .default, handler: { alert in self.performSegue(withIdentifier: "Thank You", sender: self)
                    self.currentContact.hasGoneThroughSetUp = true
                })
                alert.addAction(agree)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    // BFFThankYouForSigningInDelegate 
    func didCancelSignIn(_ sender: BFFThankYouForSigningIn) {
        self.navigationController?.popViewController(animated: true) 
    }
}
