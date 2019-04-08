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

    @IBAction func signOutContact(_ sender: AnyObject) {
        if whoIsHereIsActive == true {
            let cell : UITableViewCell = sender.view! as! ContactTableViewCell
            let indexPath = listOfPeopleTableView.indexPath(for: cell)?.row
            if let index = filteredContacts[indexPath!] as Contact? {
                shopUseLog.signOutContact(index)
                whosInTheShop(self)
            }
        }
    }
    
    @IBAction func whosInTheShop(_ sender: AnyObject) {
        filteredContacts = usersWhoAreLoggedIn()
        whoIsHereIsActive = true
        // add the underline to the button
        addAttributeToText(whos, button: whosHere)
        removeAttributeForButton(mem, button: members)
        removeAttributeForButton(vol, button: volunteers)
        listOfPeopleTableView.reloadData()
        
    }
    
    @IBAction func allVolunteers(_ sender: AnyObject) {
        filteredContacts = shopUseLog.contactsOfVolunteer()
        whoIsHereIsActive = false
        // add the underline to the button
        addAttributeToText(vol, button: volunteers)
        removeAttributeForButton(mem, button: members)
        removeAttributeForButton(whos, button: whosHere)
        listOfPeopleTableView.reloadData()
    }
    
    @IBAction func currentMembers(_ sender: AnyObject) {
        filteredContacts = contactLog.currentMembers()
        whoIsHereIsActive = false
        // add the underline to the button
        addAttributeToText(mem, button: members)
        removeAttributeForButton(vol, button: volunteers)
        removeAttributeForButton(whos, button: whosHere)
        listOfPeopleTableView.reloadData()
    }
    
    func addAttributeToText(_ text: String, button: UIButton) {
        let textRange = NSMakeRange(0, text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value:NSUnderlineStyle.single.rawValue, range: textRange)
        button.titleLabel?.attributedText = attributedText
    }
    
    func removeAttributeForButton(_ text: String, button: UIButton) {
        button.titleLabel?.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarController?.delegate = self
    }
    
    override func viewDidLoad() {
        whosInTheShop(self)
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "email"), style: .plain, target: self, action: #selector(AdminViewController.showFilterAlert))
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "myAccount"), style: .plain, target: self, action: #selector(AdminViewController.showMyAccountViewController))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Person Detail Segue" {
            let vc = segue.destination as! PersonDetailViewController
            vc.contact = selectedContact
            vc.delegate = self
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if self.tabBarController?.selectedIndex == 1 && organizationLog.hasPassword() {
            showPassWordAlert()
        }
    }
    
    @objc func showMyAccountViewController() {
        performSegue(withIdentifier: "My Account Segue", sender: self)
    }

    /// Display error alert with given message
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
            })
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPassWordAlert() {
        let alert = UIAlertController(title: "Password", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter Password:"
            textField.isSecureTextEntry = true
            self.password = textField
        })
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: { alert in
            if self.password.text != self.organizationLog.organizationLog.first?.password && self.password.text != "bikecollectives" {
                self.tabBarController?.selectedIndex = 0
            }
        }))
        alert.addAction(UIAlertAction(title: "Forgot Password", style: .default, handler: { alert in
            //send another alert
            self.showForgotPasswordAlert()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showForgotPasswordAlert() {
        let alert = UIAlertController(title: "Forgot Password", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { alert in
            self.tabBarController?.selectedIndex = 0
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Organization founded?"
            self.password = textField
        })
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: { alert in
            if self.password.text != self.organizationLog.organizationLog.first?.founded {
                self.tabBarController?.selectedIndex = 1
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
        
    @objc func showFilterAlert() {
        let alert = UIAlertController(title: "Filter", message: "What reports do you want to send?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Contacts", style: UIAlertAction.Style.default, handler: { alert in
            self.sendData(self, dataType: self.contactLog.returnAllContactsAsCommaSeporatedString())
        }))
        alert.addAction(UIAlertAction(title: "Members", style: UIAlertAction.Style.default, handler: { alert in
            self.sendData(self, dataType: self.contactLog.returnAllMembersAsCommaSeporatedString())
        }))
        alert.addAction(UIAlertAction(title: "Volunteers", style: UIAlertAction.Style.default, handler: { alert in
            self.sendData(self, dataType: self.contactLog.returnAllVolunteersAsCommaSeporatedString())
        }))
        alert.addAction(UIAlertAction(title: "Shop Use", style: UIAlertAction.Style.default, handler: { alert in
            self.sendData(self, dataType: self.shopUseLog.shopUseLogAsCommaSeporatedString())
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil ))
        self.present(alert, animated: true, completion: nil)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 1 && searchText == "" {
            listOfPeopleTableView.reloadData()
        }
        else {
            _searchContactsWithSubstring(searchText)
        }
    }
    
    func _searchContactsWithSubstring(_ substring: String) {
        let fullContactList = contactLog.allContacts
        let predicate = NSPredicate(format: "firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@ OR pin BEGINSWITH[cd] %@ OR emailAddress BEGINSWITH[cd] %@", substring, substring, substring, substring)
        filteredContacts = (fullContactList as NSArray).filtered(using: predicate) as! [Contact]
        listOfPeopleTableView.reloadData()
    }
    
    func sendData(_ sender: AnyObject, dataType: String) {
        guard MFMailComposeViewController.canSendMail() else {
            showErrorAlert(title: "Unable to Send", message: "Can't open email client.")
            return
        }

        let fileName = getDocumentsDirectory().appendingPathComponent("data.csv")
        let activityItem : Data = try! Data(contentsOf: URL(fileURLWithPath: fileName))
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients([(organizationLog.organizationLog.first?.emailAddress)!])
        mailComposeViewController.setSubject("User Data")
        mailComposeViewController.setMessageBody(dataType, isHTML: false)
        mailComposeViewController.addAttachmentData(activityItem, mimeType: "csv", fileName: "UserData.csv")
        navigationController?.present(mailComposeViewController, animated: true) {
        }
    }
    
    // mailComposeDelegateMethods
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // file creator helper (from stackoverflow...)
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func didMakeChangesToContactOnEditVC() {
        listOfPeopleTableView.reloadData()
    }
}

// Mark: - TableView Delegate -
extension AdminViewController {
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count;
    }
    func tableView(_ tableView: UITableView!,
        cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
            let cell = listOfPeopleTableView.dequeueReusableCell(withIdentifier: "CustomCell") as! ContactTableViewCell
            let contact = filteredContacts[indexPath.row]
            let membership = contact.value(forKey: "membership") as? Membership
            var title = contact.displayName()
            if contact.firstName == "" {
                title = (contact.value(forKey: "lastName") as? String)!
            }
            let membershipType = membership?.membershipType
            cell.titleLabel.text = title
            cell.detailLabel.text = membershipType
            cell.time.text = ShopUseLog().timeOfCurrentShopUseForContact(contact)
            cell.circleView.image = UIImage(named: "circle")
            cell.circleView.tintColor = contactLog.colourOfContact(contact)
            // add gesture recognizer
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AdminViewController.signOutContact(_:)))
            gestureRecognizer.direction = .left
            cell.addGestureRecognizer(gestureRecognizer)
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContact = filteredContacts[indexPath.row]
        performSegue(withIdentifier: "Person Detail Segue", sender: self)
    }
}
