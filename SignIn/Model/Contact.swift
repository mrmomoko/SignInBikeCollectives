//
//  Contact.swift
//  SignIn
//
//  Created by Momoko Saunders on 8/11/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreData

class Contact: NSManagedObject {

    @NSManaged var colour: String
    @NSManaged var emailAddress: String
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var recentUse: NSDate
    @NSManaged var pin: String
    @NSManaged var shopUse: NSSet
    @NSManaged var volunteer: NSSet
    @NSManaged var membership: Membership

}
