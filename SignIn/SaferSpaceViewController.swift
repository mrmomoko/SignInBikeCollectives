//
//  SaferSpaceViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 11/13/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class SaferSpaceViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        textView.layer.borderWidth = 3
//        textView.layer.cornerRadius = 0.2
//        textView.clipsToBounds = true
        textView.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 0.5])
        let rightBarButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "showFilterAlert")

        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
    }
}
