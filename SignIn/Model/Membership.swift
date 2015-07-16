//
//  swift.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/14/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreData

class Membership: NSManagedObject {

    @NSManaged var membershipExpiration: NSDate
    @NSManaged var membershipType: String
    @NSManaged var contact: Contact

}
