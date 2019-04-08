//
//  SaferSpaceViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 11/13/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation

protocol WaiverViewControllerDelegate {
    func didAddWaiver(_ sender:WaiverViewController)
}

class WaiverViewController: UIViewController {
    
    var delegate : WaiverViewControllerDelegate? = nil
    var org : Organization? = nil
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        textView.layer.borderWidth = 3
        //        textView.layer.cornerRadius = 0.2
        //        textView.clipsToBounds = true
        textView.layer.borderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 0.5])
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(WaiverViewController.save))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if org!.waiver != "" {
            textView.text = org!.waiver
        }
    }
    func save() {
        org!.waiver = textView.text
        OrganizationLog().saveOrg(org!)
        delegate?.didAddWaiver(self)
    }
}
