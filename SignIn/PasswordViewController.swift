//
//  PasswordViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/25/16.
//  Copyright © 2016 Momoko Saunders. All rights reserved.
//

import Foundation

protocol PasswordViewControllerDelegate {
    func didAddPassword(_ sender:PasswordViewController)
}

class PasswordViewController: UIViewController {
    
    var delegate : PasswordViewControllerDelegate? = nil
    var org : Organization? = nil
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmationPassword: UITextField!
    @IBOutlet weak var founded: UITextField!
    
    override func viewDidLoad() {
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(PasswordViewController.savePassword))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if org!.password != "" {
            password.text = org!.password
        }
    }
    
    func savePassword() {
        if password.text == confirmationPassword.text {
            if founded.text!.characters.count > 0 {
                org!.password = password.text
                OrganizationLog().saveOrg(org!)
                delegate?.didAddPassword(self)
            } else {
                sendFoundedAlert()
            }
        } else {
            sendPasswordAlert()
        }
    }
    
    func sendPasswordAlert() {
        let alert = UIAlertController(title: "Your Password and Confirm password do not match", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendFoundedAlert() {
        let alert = UIAlertController(title: "Please enter a year for Founded. This will be the answer to a security question in case you lose your password", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
