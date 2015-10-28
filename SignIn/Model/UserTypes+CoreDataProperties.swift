//
//  UserTypes+CoreDataProperties.swift
//  SignIn
//
//  Created by Momoko Saunders on 10/27/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserTypes {

    @NSManaged var coreVolunteers: NSNumber?
    @NSManaged var lifeTimeMembers: NSNumber?
    @NSManaged var oneMonthMembers: NSNumber?
    @NSManaged var sixMonthMembers: NSNumber?
    @NSManaged var staff: NSNumber?
    @NSManaged var yearlyMembers: NSNumber?
    @NSManaged var earnABike: NSNumber?
    @NSManaged var other: NSNumber?
    @NSManaged var organization: Organization?

}
