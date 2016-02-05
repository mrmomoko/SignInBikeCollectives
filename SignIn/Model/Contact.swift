//
//  Contact.swift
//  SignIn
//
//  Created by Momoko Saunders on 9/29/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreData

class Contact: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func displayName() -> String {
        if lastName?.characters.count > 0 {
            let char = String(lastName![lastName!.startIndex])
            return firstName! + " " + char
        } else {
            return firstName!
        }
    }
}
