//
//  EmployeeUse+CoreDataProperties.swift
//  SignIn
//
//  Created by Momoko Saunders on 10/19/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension EmployeeUse {

    @NSManaged var signIn: NSDate?
    @NSManaged var signOut: NSDate?
    @NSManaged var contact: Contact?

}
