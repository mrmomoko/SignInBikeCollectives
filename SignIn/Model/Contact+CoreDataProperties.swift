//
//  Contact+CoreDataProperties.swift
//  SignIn
//
//  Created by Momoko Saunders on 9/29/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var colour: String?
    @NSManaged var emailAddress: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var pin: String?
    @NSManaged var recentUse: NSDate?
    @NSManaged var recentUseType: String?
    @NSManaged var membership: Membership?
    @NSManaged var shopUse: NSSet?
}
