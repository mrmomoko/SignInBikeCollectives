//
//  Membership.swift
//  SignIn
//
//  Created by Momoko Saunders on 8/11/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreData

class Membership: NSManagedObject {

    @NSManaged var membershipExpiration: Date
    @NSManaged var membershipType: String
    @NSManaged var contact: Contact

}
