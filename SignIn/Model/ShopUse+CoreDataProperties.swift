//
//  ShopUse+CoreDataProperties.swift
//  SignIn
//
//  Created by Momoko Saunders on 11/30/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ShopUse {

    @NSManaged var signIn: NSDate?
    @NSManaged var signOut: NSDate?
    @NSManaged var contact: Contact?
    @NSManaged var type: Type?

}
