//
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class AdminViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITabBarControllerDelegate {
    var filteredContacts = [Contact]()
    let contactLog = ContactLog()
    let shopUseLog = ShopUseLog()
    var selectedContact : Contact?
    let organizationLog = OrganizationLog()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listOfPeopleTableView: UITableView!

    @IBAction func signOutContact(sender: AnyObject) {
        let cell = sender.view as! ContactTableViewCell
        let indexPath = listOfPeopleTableView.indexPathForCell(cell)?.row
        if let index = filteredContacts[indexPath!] as Contact! {
            shopUseLog.signOutContact(index)
            whosInTheShop(self)
        }
    }
    
    @IBAction func whosInTheShop(sender: AnyObject) {
        filteredContacts = usersWhoAreLoggedIn()
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarController?.delegate = self
    }
    override func viewDidLoad() {
        filteredContacts = usersWhoAreLoggedIn()
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "email"), style: .Plain, target: self, action: "showFilterAlert")
        rightBarButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 60))
        let viewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        viewButton.setBackgroundImage(UIImage(named: "cloud"), forState: .Normal)
        view.addSubview(viewButton)
        let button = UIBarButtonItem(customView: view)
        button.tintColor = UIColor.cyanColor()
        rightBarButton.tintColor = UIColor.blackColor()
        self.navigationItem.rightBarButtonItems = [rightBarButton, button]
    }
    
    override func viewDidAppear(animated: Bool) {
        // if user has a password and is coming from the other tab
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Person Detail Segue" {
            let vc = segue.destinationViewController as! PersonDetailViewController
            vc.contact = selectedContact
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if self.tabBarController?.selectedIndex == 1 && organizationLog.hasPassword() {
            showPassWordAlert()
        }
        
    }
    
    func showPassWordAlert() {
        let alert = UIAlertController(title: "Password", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler: nil))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter Password:"
            textField.secureTextEntry = false
        })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showFilterAlert() {
        //pop up an alert with the different filters?
        
    }
    
    func usersWhoAreLoggedIn() -> [Contact] {
        var loggedInUsers = [Contact]()
        for contact in ContactLog().allContacts {
            if contact.recentUse!.timeIntervalSinceNow > 0 {
                loggedInUsers.append(contact)
            }
        }
        return loggedInUsers
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.characters.count == 1 && searchText == "" {
            listOfPeopleTableView.reloadData()
        }
        else {
            _searchContactsWithSubstring(searchText)
        }
    }
    
    
    func _searchContactsWithSubstring(substring: String) {
        let fullContactList = contactLog.recentContactsWhoAreNotLoggedIn()
        let predicate = NSPredicate(format: "firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@ OR pin BEGINSWITH[cd] %@ OR emailAddress BEGINSWITH[cd] %@", substring, substring, substring, substring)
        filteredContacts = (fullContactList as NSArray).filteredArrayUsingPredicate(predicate) as! [Contact]
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
            var cell = ContactTableViewCell()
            cell = listOfPeopleTableView.dequeueReusableCellWithIdentifier("CustomCell") as! ContactTableViewCell
            let contact = filteredContacts[indexPath.row]
            let membership = contact.valueForKey("membership") as? Membership
            var title = contact.valueForKey("firstName") as? String
            if title == "" {
                title = contact.valueForKey("lastName") as? String
            }
            let membershipType = membership?.membershipType
            cell.titleLabel.text = title
            cell.detailLabel.text = membershipType // soon to be minutes of shopUse
            let circle = UIImage(named: "circle")
            cell.circleView.image = circle
            cell.circleView.tintColor = contactLog.colourOfContact(contact)
            return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedContact = filteredContacts[indexPath.row]
        performSegueWithIdentifier("Person Detail Segue", sender: self)
    }
}
