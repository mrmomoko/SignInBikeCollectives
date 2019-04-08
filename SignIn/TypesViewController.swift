//
//  TypesViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 11/30/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation
protocol TypesViewControllerDelegate {
    func didSaveType(_ sender: TypesViewController)
}

class TypesViewController : UIViewController {
    
    var org : Organization? = nil
    var delegate : TypesViewControllerDelegate? = nil
    
    @IBOutlet weak var volunteerTypeStatus: UISwitch!
    @IBOutlet weak var patronTypeStatus: UISwitch!
    @IBOutlet weak var employeeTypeStatus: UISwitch!
    @IBOutlet weak var custom1: UISwitch!
    @IBOutlet weak var customOne: UITextField!
    @IBOutlet weak var custom2: UISwitch!
    @IBOutlet weak var customTwo: UITextField!
    
    override func viewDidLoad() {
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(TypesViewController.showSaveAlert))
        self.navigationItem.rightBarButtonItem = rightBarButton
        updateOnOffSwitchesForTypes()
    }
    
    func updateOnOffSwitchesForTypes() {
        let typesStatus = TypeLog().getActiveStatusOfTypesInOrderOfIDForGroup("Contact")
        volunteerTypeStatus.isOn = typesStatus[0]
        patronTypeStatus.isOn = typesStatus[1]
        employeeTypeStatus.isOn = typesStatus[2]
        custom1.isOn = typesStatus[3]
        customOne.text = TypeLog().getType(4).title
        custom2.isOn = typesStatus[4]
        customTwo.text = TypeLog().getType(5).title
    }
    
    @objc func showSaveAlert() {
        let type1 = TypeLog().getType(1)
        if volunteerTypeStatus.isOn == true {
            type1.active = 1
        } else {
            type1.active = 0
        }
        let type2 = TypeLog().getType(2)
        if patronTypeStatus.isOn == true {
            type2.active = 1
        } else {
            type2.active = 0
        }
        let type3 = TypeLog().getType(3)
        if employeeTypeStatus.isOn == true {
            type3.active = 1
        } else {
            type3.active = 0
        }
        let type4 = TypeLog().getType(4)
        type4.title = customOne.text
        if custom1.isOn == true {
            type4.active = 1
        } else {
            type4.active = 0
        }
        let type5 = TypeLog().getType(5)
        type5.title = customTwo.text
        if custom2.isOn == true {
            type5.active = 1
        } else {
            type5.active = 0
        }
        TypeLog().saveType()
        delegate?.didSaveType(self)
    }

    
}
