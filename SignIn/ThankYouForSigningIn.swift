//
//  BFFThankYouForSigningIn.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/30/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

protocol BFFThankYouForSigningInDelegate {
    func didCancelSignIn(_ sender: BFFThankYouForSigningIn)
}

class BFFThankYouForSigningIn: UIViewController {
    var contact : Contact!
    let shopUseLog = ShopUseLog()
    let contactLog = ContactLog()
    var delegate : BFFThankYouForSigningInDelegate?
    var currentShopUse : ShopUse?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        nameLabel.text = contact.firstName
        let types = TypeLog().getAllActiveTypesForGroup("Contact")
        showAlertForUserType(types)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dismissViewControllerAfterTimeOut()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        
        if segueIdentifier == "User Info" {
            let vc = segue.destination as! PersonDetailViewController
            vc.contact = contact;
        }
    }
    
    func showAlertForUserType(_ types: [Type]) {
        
        let alert = UIAlertController(title: "How are you using the shop today?", message: nil, preferredStyle: .alert)
        var i = 0
        while i < types.count {
            let counter = i
            let shopUse = UIAlertAction(title: types[i].title, style: .default, handler: { alert in self.shopUseLog.createShopUseWithContact(self.contact!, id: Int(types[counter].id!))
            })
            alert.addAction(shopUse)
            i = i + 1
        }
        // this should only show up if the user navigated from the SigninVC
        if let d = delegate {
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { alert in
                d.didCancelSignIn(self)
            })
            alert.addAction(cancel)
        }
                                   
        present(alert, animated: true, completion: nil)
        
   }
    
    func dismissViewControllerAfterTimeOut() {
        let delay = 15.0 * Double(NSEC_PER_SEC) // change to *15 sec
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            if self.navigationController?.topViewController == self {
                self.navigationController!.popToRootViewController(animated: true)
            }
        }
    }
}


