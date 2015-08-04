//
//  SignInViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/1/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation

//let timedOutNotificationKey = "com.bikecollectives.timedOutNotificationKey"

class SignInViewController: UIViewController, UITableViewDataSource {

    let contactLog = ContactLog()
    let shopUseLog = ShopUseLog()
    var currentContact : Contact!
    var filteredLog: [Contact]
    
    @IBOutlet weak var uniqueIdentifier: UITextField!
    
    @IBOutlet weak var mostRecentSignIns: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        filteredLog = contactLog.recentUsersWhoAreNotLoggedIn
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        mostRecentSignIns.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_thankYouVCDidTimeOut", name: timedOutNotificationKey, object: nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        filteredLog = ContactLog().recentUsersWhoAreNotLoggedIn
        mostRecentSignIns.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "New User Segue" {
            let vc = segue.destinationViewController as! NewUserViewController
            let loggedInUser = contactLog.createUserWithIdentity(uniqueIdentifier.text)
            shopUseLog.createShopUseWithContact(loggedInUser)
                vc.contact = loggedInUser
        }
        if segue.identifier == "Thank You" {
            let vc = segue.destinationViewController as! BFFThankYouForSigningIn
            vc.contact = currentContact
            shopUseLog.createShopUseWithContact(currentContact)
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLog.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        if indexPath.row == 0 {
            cell.textLabel!.text = "I'm New, I don't have a login"
            // I'd like to formate this cell to look more like a button, or maybe I should put a button in it?
        } else {
            let contact = filteredLog[indexPath.row - 1]
            cell.textLabel!.text = contact.valueForKey("firstName") as? String
            cell.backgroundColor = contactLog.colourOfContact(contact)
        }
        return cell
    }
    
    func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            performSegueWithIdentifier("New User Segue", sender: self)
        } else {
            currentContact = filteredLog[indexPath.row - 1]
            performSegueWithIdentifier("Thank You", sender: self)
        }
    }
    func showAlertForCompleteForm() {
        let alert = UIAlertController(title: "Are you here to work on your bike or volunteer", message: nil, preferredStyle: .Alert)
        let shopUse = UIAlertAction(title: "Use the Shop", style: .Default, handler: nil)
        alert.addAction(shopUse)
        let volunteer = UIAlertAction(title: "Volunteer", style: .Default, handler: nil)
        alert.addAction(volunteer)
        presentViewController(alert, animated: true, completion: {self.performSegueWithIdentifier("Thank You", sender: self)})
    }
    
    func _thankYouVCDidTimeOut() {
        
        
    }
}