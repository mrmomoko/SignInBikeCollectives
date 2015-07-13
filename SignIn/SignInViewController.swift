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
    var filteredLog: [Contact]
    
    @IBOutlet weak var uniqueIdentifier: UITextField!
    
    @IBOutlet weak var mostRecentSignIns: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        filteredLog = contactLog.recentUsersWhoAreNotLoggedIn
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"Sign In\""
        mostRecentSignIns.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidAppear(animated: Bool) {
        filteredLog = contactLog.recentUsersWhoAreNotLoggedIn
        mostRecentSignIns.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "New User Segue" {
            let vc = segue.destinationViewController as! NewUserViewController
            if let identity = uniqueIdentifier?.text! {
                let loggedInUser = contactLog.createUserWithIdentity(identity)
                vc.contact = loggedInUser
            }
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
        }
        return cell
    }
    
    func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("New User Segue", sender: self)
        default:
            performSegueWithIdentifier("Thank You", sender: self)
        }
    }
}