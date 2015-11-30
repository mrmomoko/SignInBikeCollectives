//
//  Type+CoreDataProperties.swift
//  SignIn
//
//  Created by Momoko Saunders on 11/29/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Type {

    @NSManaged var title: String?
    @NSManaged var active: NSNumber?
    @NSManaged var shopUse: NSSet?
    @NSManaged var organization: Organization?
    @NSManaged var contact: NSSet?

}
