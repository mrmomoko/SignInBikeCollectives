//
//  Organization+CoreDataProperties.swift
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

extension Organization {

    @NSManaged var defaultSignOutTime: NSNumber?
    @NSManaged var emailAddress: String?
    @NSManaged var image: NSData?
    @NSManaged var isMasterDevice: NSNumber?
    @NSManaged var name: String?
    @NSManaged var password: String?
    @NSManaged var saferSpaceAgreement: String?
    @NSManaged var waiver: String?
    @NSManaged var yesOrNoQuestion: String?
    @NSManaged var zipCode: String?
    @NSManaged var type: NSSet?

}
