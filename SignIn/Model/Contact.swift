//
//  Contact.swift
//  SignIn
//
//  Created by Momoko Saunders on 9/29/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Contact: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func displayName() -> String {
        if lastName?.count > 0 {
            let char = String(lastName![lastName!.startIndex])
            return firstName! + " " + char
        } else {
            return firstName!
        }
    }
}
