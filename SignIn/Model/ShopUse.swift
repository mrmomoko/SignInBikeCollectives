//
//  BCNShopUse.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/7/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreData

class ShopUse: NSManagedObject {

    @NSManaged var membershipType: NSNumber
    @NSManaged var numberOfHoursLogged: NSDate
    @NSManaged var signIn: NSDate
    @NSManaged var signOut: NSDate
    @NSManaged var timestamp: NSDate
    @NSManaged var userIdentity: String
    @NSManaged var volunteer: NSNumber
    @NSManaged var contact: Contact

}
