//
//  MemberTypeViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 12/7/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class MemberTypeViewController : UIViewController {
    
    let org = OrganizationLog().currentOrganization().organization
    
    @IBOutlet weak var monthSwitch: UISwitch!
    @IBOutlet weak var sixMonthSwitch: UISwitch!
    @IBOutlet weak var yearlySwitch: UISwitch!
    @IBOutlet weak var lifetimeSwitch: UISwitch!
    @IBOutlet weak var customSwitch: UISwitch!
    @IBOutlet weak var customText: UITextField!
    
    @IBAction func oneMonthAction(sender: AnyObject) {
        let type = TypeLog().getType("One Month")
        if monthSwitch.on == true {
            type.active = 1
        } else {
            type.active = 0
        }

    }
    @IBAction func sixMonthAction(sender: AnyObject) {
        let type = TypeLog().getType("Six Month")
        if sixMonthSwitch.on == true {
            type.active = 1
        } else {
            type.active = 0
        }

    }
    @IBAction func yearlyAction(sender: AnyObject) {
        let type = TypeLog().getType("Yearly")
        if yearlySwitch.on == true {
            type.active = 1
        } else {
            type.active = 0
        }

    }
    @IBAction func lifetimeAction(sender: AnyObject) {
        let type = TypeLog().getType("Life Time")
        if lifetimeSwitch.on == true {
            type.active = 1
        } else {
            type.active = 0
        }

    }
    @IBAction func customAction(sender: AnyObject) {
        let type = TypeLog().getType("Custom")
        if customSwitch.on == true {
            type.title = customText.text
            type.active = 1
        } else {
            type.active = 0
        }
    }
    
    override func viewDidLoad() {
        // turn on and off the correct switches
        let rightBarButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "showSaveAlert")
        self.navigationItem.rightBarButtonItem = rightBarButton
        updateOnOffSwitchesForTypes()
    }
    
    func updateOnOffSwitchesForTypes() {
        let typesStatus = TypeLog().getActiveStatusOfTypesInOrderOfIDForGroup("Membership")
        monthSwitch.on = typesStatus[0]
        sixMonthSwitch.on = typesStatus[1]
        yearlySwitch.on = typesStatus[2]
        lifetimeSwitch.on = typesStatus[3]
        customSwitch.on = typesStatus[4]
    }
    
    func showSaveAlert() {
        TypeLog().saveType()
    }
}
