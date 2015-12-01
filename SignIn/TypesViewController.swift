//
//  TypesViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 11/30/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation
class TypesViewController : UIViewController {
    
    @IBOutlet weak var voluteerTypeStatus: UISwitch!
    @IBOutlet weak var PatronTypeStatus: UISwitch!
    @IBOutlet weak var EmployeeTypeStatus: UISwitch!
    
    @IBAction func volunteerType(sender: AnyObject) {
        let type = TypeLog().getType("Volunteer")
        if voluteerTypeStatus.on == true {
            type.active = 1
        } else {
            type.active = 0
        }
    }
    @IBAction func patronType(sender: AnyObject) {
    }
    @IBAction func employeeType(sender: AnyObject) {
    }
    
}
