//
//  SignInViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/1/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class SignInViewController: UIViewController, UITableViewDataSource {
    
    var filteredLog = ContactLog().recentUsersWhoAreNotLoggedIn
//    var temporaryLog = [BCNContact]()
    
    
    @IBOutlet weak var uniqueIdentifier: UITextField!
    
    @IBOutlet weak var mostRecentSignIns: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "\"Sign In\""
        mostRecentSignIns.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    override func viewDidAppear(animated: Bool) {
        mostRecentSignIns.reloadData()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLog.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        as! UITableViewCell
        
        if indexPath.row == 0 {
            cell.textLabel!.text = "I'm New, I don't have a login"
            
        } else {
            let contact = filteredLog[indexPath.row - 1]
        cell.textLabel!.text = contact.valueForKey("firstName") as? String
        }
        return cell
    }
    func tableView( tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            switch indexPath.row {
            case 0:
                performSegueWithIdentifier("New User Segue", sender: self)
                if let identifier = uniqueIdentifier?.text! {
                    self.saveName(identifier)
                    
                }

            default:
                performSegueWithIdentifier("Thank You", sender: self)
            }
            
    }
    func saveName(name: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedContext)
        
        let contact = NSManagedObject(entity: entity!,  insertIntoManagedObjectContext: managedContext)
        
        contact.setValue(name, forKey: "firstName")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        filteredLog.append(contact)
    }
}