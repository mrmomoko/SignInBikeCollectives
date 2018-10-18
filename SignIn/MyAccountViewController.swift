//
//  MyAccountViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 9/30/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class MyAccountViewController : UITableViewController, SaferSpaceViewControllerDelegate, WaiverViewControllerDelegate, TypesViewControllerDelegate, MemberTypeViewControllerDelegate, PasswordViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    let org = OrganizationLog().organizationLog.first
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var defaultSignOut: UITextField!
    @IBOutlet weak var saferSpaceText: UILabel!
    @IBOutlet weak var waiverText: UILabel!
    @IBOutlet weak var yesOrNoQuestion: UITextField!

    func sendData() {
        guard MFMailComposeViewController.canSendMail() else {
            showErrorAlert(title: "Unable to Send", message: "Can't open email client.")
            return
        }

        let mailComposeViewController = MFMailComposeViewController()

        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["analyst@bikefarm.org"])
        mailComposeViewController.setSubject("Organization Data")
        mailComposeViewController.setMessageBody(OrganizationLog().orgData(), isHTML: false)
        navigationController?.present(mailComposeViewController, animated: true) {
        }
    }
    
    // mailComposeDelegateMethods
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(MyAccountViewController.showSaveAlert))
        let uploadButton = UIBarButtonItem(image: UIImage(named: "cloud"), style: .plain, target: self, action: #selector(MyAccountViewController.sendData))
        uploadButton.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        self.navigationItem.rightBarButtonItems = [rightBarButton, uploadButton]
        
        name.text = org!.name
        emailAddress.text = org!.emailAddress
        zipCode.text = org!.zipCode
        defaultSignOut.text = String(describing: (org!.defaultSignOutTime)!)
        yesOrNoQuestion.text = org!.yesOrNoQuestion
        saferSpaceText.text = org?.saferSpaceAgreement
        waiverText.text = org?.waiver

     }
    
    override func viewDidAppear(_ animated: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MyAccountViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        
        if segueIdentifier == "Safer Space Segue" {
            let vc = segue.destination as! SaferSpaceViewController
            vc.delegate = self
            vc.org = org
        }
        if segueIdentifier == "Waiver Segue" {
            let vc = segue.destination as! WaiverViewController
            vc.delegate = self
            vc.org = org
        }
        if segueIdentifier == "Types Segue" {
            let vc = segue.destination as! TypesViewController
            vc.delegate = self
            vc.org = org
        }
        if segueIdentifier == "Members Segue" {
            let vc = segue.destination as! MemberTypeViewController
            vc.delegate = self
            vc.org = org
        }
        if segueIdentifier == "Password Segue" {
            let vc = segue.destination as! PasswordViewController
            vc.delegate = self
            vc.org = org
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    /// Display error alert with given message
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSaveAlert() {
        org!.name = name.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        org!.emailAddress = emailAddress.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        org!.zipCode = zipCode.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        org!.defaultSignOutTime = Int(defaultSignOut.text!) as! NSNumber
        org!.yesOrNoQuestion = yesOrNoQuestion.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        OrganizationLog().saveOrg(org!)
    }
    
    // safer space delegate
    func didAddSaferSpaceAggrement(_ sender:SaferSpaceViewController) {
        self.navigationController?.popViewController(animated: true)
        saferSpaceText.text = org?.saferSpaceAgreement
    }

    func didAddWaiver(_ sender: WaiverViewController) {
        self.navigationController?.popViewController(animated: true)
        waiverText.text = org?.waiver
    }
    
    func didSaveType(_ sender: TypesViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didSaveMemberType(_ sender: MemberTypeViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didAddPassword(_ sender: PasswordViewController) {
        self.navigationController?.popViewController(animated: true)
    }
}
