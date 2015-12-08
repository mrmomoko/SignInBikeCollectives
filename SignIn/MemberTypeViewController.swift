//
//  MemberTypeViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 12/7/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class MemberTypeViewController : UIViewController {
    
    @IBOutlet weak var monthSwitch: UISwitch!
    @IBOutlet weak var sixMonthSwitch: UISwitch!
    @IBOutlet weak var yearlySwitch: UISwitch!
    @IBOutlet weak var lifetimeSwitch: UISwitch!
    @IBOutlet weak var customSwitch: UISwitch!
    
    @IBAction func oneMonthAction(sender: AnyObject) {
    }
    @IBAction func sixMonthAction(sender: AnyObject) {
    }
    @IBAction func yearlyAction(sender: AnyObject) {
    }
    @IBAction func lifetimeAction(sender: AnyObject) {
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

    }
}
