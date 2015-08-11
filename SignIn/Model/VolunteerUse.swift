//
//  VolunteerUse.swift
//  SignIn
//
//  Created by Momoko Saunders on 8/11/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreData

class VolunteerUse: NSManagedObject {

    @NSManaged var signIn: NSDate
    @NSManaged var signOut: NSDate
    @NSManaged var contact: Contact

}
