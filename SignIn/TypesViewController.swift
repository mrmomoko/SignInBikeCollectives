//
//  TypesViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 11/30/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation
// should likely change to tableView
class TypesViewController : UIViewController {
    
    var org : Organization? = nil
    
    @IBOutlet weak var volunteerTypeStatus: UISwitch!
    @IBOutlet weak var patronTypeStatus: UISwitch!
    @IBOutlet weak var employeeTypeStatus: UISwitch!
    
    @IBAction func volunteerType(sender: AnyObject) {
        let type = TypeLog().getType("Volunteer")
        if volunteerTypeStatus.on == true {
            type.active = 1
        } else {
            type.active = 0
        }
    }
    @IBAction func patronType(sender: AnyObject) {
    }
    @IBAction func employeeType(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        let rightBarButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "showSaveAlert")
        self.navigationItem.rightBarButtonItem = rightBarButton
        updateOnOffSwitchesForTypes()
    }
    func updateOnOffSwitchesForTypes() {
        let types = org?.type // an nsSet
        for type in types! {
            if type.title == "Volunteer"  {
                if type.active == 1 {
                    volunteerTypeStatus.on = true
                } else {
                    volunteerTypeStatus.on = false
                }
            }
            if type.title == "Patron"  {
                if type.active == 1 {
                    volunteerTypeStatus.on = true
                } else {
                    volunteerTypeStatus.on = false
                }
            }
            if type.title == "Employee"  {
                if type.active == 1 {
                    volunteerTypeStatus.on = true
                } else {
                    volunteerTypeStatus.on = false
                }
            }
            if type.title == "Custom 1"  {
                if type.active == 1 {
                    volunteerTypeStatus.on = true
                } else {
                    volunteerTypeStatus.on = false
                }
            }
            if type.title == "Custom 2"  {
                if type.active == 1 {
                    volunteerTypeStatus.on = true
                } else {
                    volunteerTypeStatus.on = false
                }
            }

        }
        
        
    }
    func showSaveAlert() {
        TypeLog().saveType()
    }

    
}
