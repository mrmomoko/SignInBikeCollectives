//
//  NewUserViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/8/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class NewUserViewController: UIViewController, UITableViewDelegate {
    
    var contact : Contact?
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pin: UITextField!
    
    @IBOutlet weak var colourTableView: UITableView!
    
    @IBAction func save(sender: AnyObject) {
        // set the contacts properties
        contact!.firstName = firstName.text
        contact!.lastName = lastName.text
        contact!.emailAddress = email.text
        contact!.pin = pin.text

        // save contact
        ContactLog().saveContact(contact!)
        
        // dismiss view controller 
        // should I use a delegate call back?
    
        self.dismissViewControllerAnimated(false, completion: nil)
    }

}

extension NewUserViewController {
    // why do I override?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        firstName.text = contact!.firstName
    }
}

// Mark: - TableView Delegate -
extension NewUserViewController {
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            var cell = UITableViewCell()
            if tableView == colourTableView {
                if indexPath.row == 0 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Purple Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.purpleColor()
                }
                else if indexPath.row == 1 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Blue Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.cyanColor()
                }
                else if indexPath.row == 2 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Green Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.greenColor()
                }
                else if indexPath.row == 3 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Yellow Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.yellowColor()
                }
                else if indexPath.row == 4 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Orange Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.orangeColor()
                }
                else if indexPath.row == 5 {
                    cell = colourTableView.dequeueReusableCellWithIdentifier("Red Cell") as! UITableViewCell
                    cell.backgroundColor = UIColor.redColor()
                }
            }
            return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == colourTableView {
            if indexPath.row == 0 {
                contact!.colour = 0
                view.backgroundColor = UIColor.purpleColor()
            }
            else if indexPath.row == 1 {
                contact!.colour = 1
                view.backgroundColor = UIColor.cyanColor()
            }
            else if indexPath.row == 2 {
                contact!.colour = 2
                view.backgroundColor = UIColor.greenColor()
            }
            else if indexPath.row == 3 {
                contact!.colour = 3
                view.backgroundColor = UIColor.yellowColor()
            }
            else if indexPath.row == 4 {
                contact!.colour = 4
                view.backgroundColor = UIColor.orangeColor()
            }
            else if indexPath.row == 5 {
                contact!.colour = 5
                view.backgroundColor = UIColor.redColor()
                
            }
        }
    }
}
