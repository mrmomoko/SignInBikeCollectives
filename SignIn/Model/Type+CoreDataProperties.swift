//
//  Type+CoreDataProperties.swift
//  SignIn
//
//  Created by Momoko Saunders on 12/7/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Type {

    @NSManaged var active: NSNumber?
    @NSManaged var title: String?
    @NSManaged var id: NSNumber?
    @NSManaged var group: String?
    @NSManaged var contact: NSSet?
    @NSManaged var organization: Organization?
    @NSManaged var shopUse: NSSet?

}
