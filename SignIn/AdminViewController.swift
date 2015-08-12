//
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class AdminViewController: UIViewController, UITableViewDelegate  {
    var filteredContacts = [Contact]()
    let contactLog = ContactLog()
    let shopUseLog = ShopUseLog()
    @IBOutlet weak var listOfPeopleTableView: UITableView!

    @IBAction func whosInTheShop(sender: AnyObject) {
        filteredContacts = contactLog.usersWhoAreLoggedIn()
        listOfPeopleTableView.reloadData()
    }
    @IBAction func allVolunteers(sender: AnyObject) {
        listOfPeopleTableView.reloadData()
    }
    @IBAction func currentMembers(sender: AnyObject) {
        listOfPeopleTableView.reloadData()
    }
}

// Mark: - TableView Delegate -
extension AdminViewController {
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count;
    }
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            var cell = UITableViewCell()
            cell = listOfPeopleTableView.dequeueReusableCellWithIdentifier("person") as! UITableViewCell
            let contact = filteredContacts[indexPath.row]
            cell.textLabel?.text = contact.firstName
            cell.backgroundColor = contactLog.colourOfContact(contact)
            return cell
                
    }
}
