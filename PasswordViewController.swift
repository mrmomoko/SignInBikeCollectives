//
//  PasswordViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/25/16.
//  Copyright © 2016 Momoko Saunders. All rights reserved.
//

import Foundation

protocol PasswordViewControllerDelegate {
    func didAddPassword(sender:PasswordViewController)
}

class PasswordViewController: UIViewController {
    
    var delegate : PasswordViewControllerDelegate? = nil
    var org : Organization? = nil
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmationPassword: UITextField!
    @IBOutlet weak var founded: UITextField!
    
    override func viewDidLoad() {
        let rightBarButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "savePassword")
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewDidAppear(animated: Bool) {
        if org!.password != "" {
            password.text = org!.password
        }
    }
    func savePassword() {
        if password.text == confirmationPassword.text {
        org!.password = password.text
        OrganizationLog().saveOrg(org!)
        delegate?.didAddPassword(self)
        } else {
            
        }
    }
    
    func sendPasswordAlert() {
        
    }
}
