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
    }
    @IBAction func customAction(sender: AnyObject) {
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
        let type1 = TypeLog().getType(6)
        if monthSwitch.on == true {
            type1.active = 1
        } else {
            type1.active = 0
        }
        let type2 = TypeLog().getType(7)
        if sixMonthSwitch.on == true {
            type2.active = 1
        } else {
            type2.active = 0
        }
        let type3 = TypeLog().getType(8)
        if yearlySwitch.on == true {
            type3.active = 1
        } else {
            type3.active = 0
        }
        let type4 = TypeLog().getType(9)
        if lifetimeSwitch.on == true {
            type4.active = 1
        } else {
            type4.active = 0
        }
        let type5 = TypeLog().getType(10)
        type5.title = customText.text
        if customSwitch.on == true {
            type5.active = 1
        } else {
            type5.active = 0
        }
        TypeLog().saveType()
    }
}
