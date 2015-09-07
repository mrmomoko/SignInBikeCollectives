//
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class AdminViewController: UIViewController, UITableViewDelegate  {
    var filteredContacts = [Contact]()
    let contactLog = ContactLog()
    let shopUseLog = ShopUseLog()
    var selectedContact : Contact?
    
    @IBOutlet weak var listOfPeopleTableView: UITableView!

    @IBAction func whosInTheShop(sender: AnyObject) {
        filteredContacts = contactLog.usersWhoAreLoggedIn()
        listOfPeopleTableView.reloadData()
    }
    
    @IBAction func allVolunteers(sender: AnyObject) {
        filteredContacts = shopUseLog.contactsOfVolunteers()
        listOfPeopleTableView.reloadData()
    }
    
    @IBAction func currentMembers(sender: AnyObject) {
        filteredContacts = MembershipLog().contactsOfMemberships()
        listOfPeopleTableView.reloadData()
    }
    
    required init(coder aDecoder: NSCoder) {
        selectedContact = contactLog.createUserWithIdentity("")
        super.init(coder: aDecoder)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Person Detail Segue" {
            let vc = segue.destinationViewController as! PersonDetailViewController
            vc.contact = selectedContact
        }
    }
}

// Mark: - TableView Delegate -
extension AdminViewController {
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count;
    }
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            var cell = ContactTableViewCell()
            cell = listOfPeopleTableView.dequeueReusableCellWithIdentifier("CustomCell") as! ContactTableViewCell
            let contact = filteredContacts[indexPath.row]
            cell.textLabel?.text = contact.firstName
            cell.backgroundColor = contactLog.colourOfContact(contact)
            return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedContact = filteredContacts[indexPath.row]
        performSegueWithIdentifier("Person Detail Segue", sender: self)
    }
}
