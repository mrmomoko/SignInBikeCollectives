//
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class AdminViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITabBarControllerDelegate, PersonDetailViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    var filteredContacts = [Contact]()
    let contactLog = ContactLog()
    let shopUseLog = ShopUseLog()
    var selectedContact : Contact?
    let organizationLog = OrganizationLog()
    var password = UITextField()
    var whoIsHereIsActive = Bool()
    let whos = "Who's here"
    let mem = "Members"
    let vol = "Volunteers"
   
    @IBOutlet weak var whosHere: UIButton!
    @IBOutlet weak var members: UIButton!
    @IBOutlet weak var volunteers: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listOfPeopleTableView: UITableView!

    @IBAction func signOutContact(sender: AnyObject) {
        if whoIsHereIsActive == true {
            let cell : UITableViewCell = sender.view! as! ContactTableViewCell
            let indexPath = listOfPeopleTableView.indexPathForCell(cell)?.row
            if let index = filteredContacts[indexPath!] as Contact! {
                shopUseLog.signOutContact(index)
                whosInTheShop(self)
            }
        }
    }
    
    @IBAction func whosInTheShop(sender: AnyObject) {
        filteredContacts = usersWhoAreLoggedIn()
        whoIsHereIsActive = true
        // add the underline to the button
        addAttributeToText(whos, button: whosHere)
        removeAttributeForButton(mem, button: members)
        removeAttributeForButton(vol, button: volunteers)
        listOfPeopleTableView.reloadData()
        
    }
    
    @IBAction func allVolunteers(sender: AnyObject) {
        filteredContacts = shopUseLog.contactsOfVolunteer()
        whoIsHereIsActive = false
        // add the underline to the button
        addAttributeToText(vol, button: volunteers)
        removeAttributeForButton(mem, button: members)
        removeAttributeForButton(whos, button: whosHere)
        listOfPeopleTableView.reloadData()
    }
    
    @IBAction func currentMembers(sender: AnyObject) {
        filteredContacts = contactLog.currentMembers()
        whoIsHereIsActive = false
        // add the underline to the button
        addAttributeToText(mem, button: members)
        removeAttributeForButton(vol, button: volunteers)
        removeAttributeForButton(whos, button: whosHere)
        listOfPeopleTableView.reloadData()
    }
    
    func addAttributeToText(text: String, button: UIButton) {
        let textRange = NSMakeRange(0, text.characters.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.StyleSingle.rawValue, range: textRange)
        button.titleLabel?.attributedText = attributedText
    }
    
    func removeAttributeForButton(text: String, button: UIButton) {
        button.titleLabel?.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarController?.delegate = self
    }
    
    override func viewDidLoad() {
        whosInTheShop(self)
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "email"), style: .Plain, target: self, action: "showFilterAlert")
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "myAccount"), style: .Plain, target: self, action: "showMyAccountViewController")
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Person Detail Segue" {
            let vc = segue.destinationViewController as! PersonDetailViewController
            vc.contact = selectedContact
            vc.delegate = self
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if self.tabBarController?.selectedIndex == 1 && organizationLog.hasPassword() {
            showPassWordAlert()
        }
    }
    
    func showMyAccountViewController() {
        performSegueWithIdentifier("My Account Segue", sender: self)
    }

    /// Display error alert with given message
    func showErrorAlert(title title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel) { action in
            self.dismissViewControllerAnimated(true, completion: nil)
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showPassWordAlert() {
        let alert = UIAlertController(title: "Password", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter Password:"
            textField.secureTextEntry = true
            self.password = textField
        })
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler: { alert in
            if self.password.text != self.organizationLog.organizationLog.first?.password && self.password.text != "bikecollectives" {
                self.tabBarController?.selectedIndex = 0
            }
        }))
        alert.addAction(UIAlertAction(title: "Forgot Password", style: .Default, handler: { alert in
            //send another alert
            self.showForgotPasswordAlert()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showForgotPasswordAlert() {
        let alert = UIAlertController(title: "Forgot Password", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { alert in
            self.tabBarController?.selectedIndex = 0
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Organization founded?"
            self.password = textField
        })
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler: { alert in
            if self.password.text != self.organizationLog.organizationLog.first?.founded {
                self.tabBarController?.selectedIndex = 1
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
        
    func showFilterAlert() {
        let alert = UIAlertController(title: "Filter", message: "What reports do you want to send?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Contacts", style: UIAlertActionStyle.Default, handler: { alert in
            self.sendData(self, dataType: self.contactLog.returnAllContactsAsCommaSeporatedString())
        }))
        alert.addAction(UIAlertAction(title: "Members", style: UIAlertActionStyle.Default, handler: { alert in
            self.sendData(self, dataType: self.contactLog.returnAllMembersAsCommaSeporatedString())
        }))
        alert.addAction(UIAlertAction(title: "Volunteers", style: UIAlertActionStyle.Default, handler: { alert in
            self.sendData(self, dataType: self.contactLog.returnAllVolunteersAsCommaSeporatedString())
        }))
        alert.addAction(UIAlertAction(title: "Shop Use", style: UIAlertActionStyle.Default, handler: { alert in
            self.sendData(self, dataType: self.shopUseLog.shopUseLogAsCommaSeporatedString())
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // this is a copy of the function used in Sign In, is there a way to move this to ContactLog?
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
        let fullContactList = contactLog.allContacts
        let predicate = NSPredicate(format: "firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@ OR pin BEGINSWITH[cd] %@ OR emailAddress BEGINSWITH[cd] %@", substring, substring, substring, substring)
        filteredContacts = (fullContactList as NSArray).filteredArrayUsingPredicate(predicate) as! [Contact]
        listOfPeopleTableView.reloadData()
    }
    
    func sendData(sender: AnyObject, dataType: String) {
        guard MFMailComposeViewController.canSendMail() else {
            showErrorAlert(title: "Unable to Send", message: "Can't open email client.")
            return
        }

        let fileName = getDocumentsDirectory().stringByAppendingPathComponent("data.csv")
        let activityItem : NSData = NSData(contentsOfFile: fileName)!
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients([(organizationLog.organizationLog.first?.emailAddress)!])
        mailComposeViewController.setSubject("User Data")
        mailComposeViewController.setMessageBody(dataType, isHTML: false)
        mailComposeViewController.addAttachmentData(activityItem, mimeType: "csv", fileName: "UserData.csv")
        navigationController?.presentViewController(mailComposeViewController, animated: true) {
        }
    }
    
    // mailComposeDelegateMethods
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // file creator helper (from stackoverflow...)
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func didMakeChangesToContactOnEditVC() {
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
            let cell = listOfPeopleTableView.dequeueReusableCellWithIdentifier("CustomCell") as! ContactTableViewCell
            let contact = filteredContacts[indexPath.row]
            let membership = contact.valueForKey("membership") as? Membership
            var title = contact.displayName()
            if contact.firstName == "" {
                title = (contact.valueForKey("lastName") as? String)!
            }
            let membershipType = membership?.membershipType
            cell.titleLabel.text = title
            cell.detailLabel.text = membershipType
            cell.time.text = ShopUseLog().timeOfCurrentShopUseForContact(contact)
            cell.circleView.image = UIImage(named: "circle")
            cell.circleView.tintColor = contactLog.colourOfContact(contact)
            // add gesture recognizer
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: "signOutContact:")
            gestureRecognizer.direction = .Left
            cell.addGestureRecognizer(gestureRecognizer)
            return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedContact = filteredContacts[indexPath.row]
        performSegueWithIdentifier("Person Detail Segue", sender: self)
    }
}
