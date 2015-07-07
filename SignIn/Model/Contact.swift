//
//  Contact.swift
//  
//
//  Created by Momoko Saunders on 7/6/15.
//
//

import Foundation
import CoreData

class Contact: NSManagedObject {

    @NSManaged var colour: NSNumber
    @NSManaged var emailAddress: String
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var membershipExpiration: NSDate
    @NSManaged var pin: String
    @NSManaged var membership: Membership
    @NSManaged var shopUse: BCNShopUse

}
