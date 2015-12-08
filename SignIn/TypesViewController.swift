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
    @IBOutlet weak var custom1: UISwitch!
    @IBOutlet weak var customOne: UITextField!
    @IBOutlet weak var custom2: UISwitch!
    @IBOutlet weak var customTwo: UITextField!
    
    @IBAction func volunteerType(sender: AnyObject) {
        let type = TypeLog().getType("Volunteer")
        if volunteerTypeStatus.on == true {
            type.active = 1
        } else {
            type.active = 0
        }
    }
    @IBAction func patronType(sender: AnyObject) {
        let type = TypeLog().getType("Patron")
        if patronTypeStatus.on == true {
            type.active = 1
        } else {
            type.active = 0
        }
    }
    @IBAction func employeeType(sender: AnyObject) {
        let type = TypeLog().getType("Employee")
        if employeeTypeStatus.on == true {
            type.active = 1
        } else {
            type.active = 0
        }
    }
    @IBAction func custom1(sender: AnyObject) {
        let type = TypeLog().getType("Custom1")
        if custom1.on == true {
            type.title = customOne.text
            type.active = 1
        } else {
            type.active = 0
        }
    }
    @IBAction func custom2(sender: AnyObject) {
        let type = TypeLog().getType("Custom2")
        if custom2.on == true {
            type.title = customTwo.text
            type.active = 1
        } else {
            type.active = 0
        }
    }
    
    
    override func viewDidLoad() {
        let rightBarButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "showSaveAlert")
        self.navigationItem.rightBarButtonItem = rightBarButton
        updateOnOffSwitchesForTypes()
    }
    func updateOnOffSwitchesForTypes() {
        let typesStatus = TypeLog().getActiveStatusOfTypesInOrderOfIDForGroup("Contact")
        volunteerTypeStatus.on = typesStatus[0]
        patronTypeStatus.on = typesStatus[1]
        employeeTypeStatus.on = typesStatus[2]
        custom1.on = typesStatus[3]
        custom2.on = typesStatus[4]
    }
    func showSaveAlert() {
        TypeLog().saveType()
    }

    
}
