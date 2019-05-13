//
//  NewUserViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/8/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class NewUserViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var contact : Contact?
    var contactIndentifier : String?
    let contactLog = ContactLog()
    let shopUseLog = ShopUseLog()
    let orgLog = OrganizationLog()
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pin: UITextField!
    @IBOutlet weak var permissionToEmail: UISwitch!
    @IBOutlet weak var yesNoQuestion: UILabel!
    
    @IBAction func save(_ sender: AnyObject) {
        if firstName.text == "" && lastName.text == "" && email.text == "" {
            showAlertForIncompleteForm()
        } else {
        // set the contacts properties
            contact!.firstName = firstName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        contact!.lastName = lastName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        contact!.emailAddress = email.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        contact!.pin = pin.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        contact!.yesOrNoQuestion = permissionToEmail.isOn as NSNumber

        // save contact
        contactLog.saveContact(contact!)
        
        // show waiver
        showWaiverForCompleteForm()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        permissionToEmail.tintColor = Colors().blue
        permissionToEmail.onTintColor = Colors().blue

        contact = contactLog.createUserWithIdentity(contactIndentifier!)
        firstName.text = contact!.firstName
        let yesNo = orgLog.currentOrganization().organization?.yesOrNoQuestion
        yesNoQuestion.text = yesNo
        if yesNo == "" {
            yesNoQuestion.isHidden = true
            permissionToEmail.isHidden = true
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewUserViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firstName.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if firstName.text == "" && lastName.text == "" && email.text == "" {
            //delete the contact from the data base
            contactLog.deleteContact(contact!)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Thank You" {
            let vc = segue.destination as! BFFThankYouForSigningIn
            vc.contact = contact!
        }
    }
}

// Mark: - CollectionView Delegate -

extension NewUserViewController {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CircleCollectionViewCell
        let image = UIImage(named: "circle")
        cell.circleImage.image = image
        
        if indexPath.row == 0 {
            cell.circleImage.tintColor = Colors().purple
        }
        else if indexPath.row == 1 {
            cell.circleImage.tintColor = Colors().blue
        }
        else if indexPath.row == 2 {
            cell.circleImage.tintColor = Colors().green
        }
        else if indexPath.row == 3 {
            cell.circleImage.tintColor = Colors().yellow
        }
        else if indexPath.row == 4 {
            cell.circleImage.tintColor = Colors().orange
        }
        else if indexPath.row == 5 {
            cell.circleImage.tintColor = Colors().red
        }
    return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            contactLog.editColourForContact(contact!, colour: .purple)
            collectionView.backgroundColor = Colors().purpleHighlight
        }
        else if indexPath.row == 1 {
            contactLog.editColourForContact(contact!, colour: .blue)
            collectionView.backgroundColor = Colors().blueHighlight
        }
        else if indexPath.row == 2 {
            contactLog.editColourForContact(contact!, colour: .green)
            collectionView.backgroundColor = Colors().greenHighlight
        }
        else if indexPath.row == 3 {
            contactLog.editColourForContact(contact!, colour: .yellow)
            collectionView.backgroundColor = Colors().yellowHighlight
        }
        else if indexPath.row == 4 {
            contactLog.editColourForContact(contact!, colour: .orange)
            collectionView.backgroundColor = Colors().orangeHighlight
        }
        else if indexPath.row == 5 {
            contactLog.editColourForContact(contact!, colour: .red)
            collectionView.backgroundColor = Colors().redHighlight
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showAlertForIncompleteForm() {
        let alert = UIAlertController(title: "Did you mean to save", message: "You need to fill in at least one field to create a user", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func showWaiverForCompleteForm () {
        if let waiver = orgLog.currentOrganization().organization!.waiver {
            if waiver == "" {
                performSegue(withIdentifier: "Thank You", sender: self)
            } else {
                let alert = UIAlertController(title: "Waiver", message: waiver, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                let agree = UIAlertAction(title: "I Agree", style: .default, handler: { alert in self.performSegue(withIdentifier: "Thank You", sender: self)
                })
                alert.addAction(agree)
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
