//
//  MembershipLog.swift
//  SignIn
//
//  Created by Momoko Saunders on 8/12/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreData

class MembershipLog: NSObject {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var membershipLog : [Membership]

    enum MembershipType: String {
        case
        NonMember = "Non Member",
        Monthly = "Monthly",
        SixMonth = "6 Month",
        Yearly = "Yearly",
        LifeTime = "Life Time"
    }
    
    override init() {
        membershipLog = [Membership]()
        let fetchRequest = NSFetchRequest(entityName: "Membership")
        var error: NSError?
        
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest,
            error: &error) as? [Membership]
        
        if let results = fetchedResults {
            membershipLog = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        super.init()
    }
    
    func createMembershipWithContact(contact: Contact) {
        
        let entity = NSEntityDescription.entityForName("Membership", inManagedObjectContext: managedObjectContext)
        
        let membership = Membership(entity: entity!,  insertIntoManagedObjectContext: managedObjectContext)
        membership.membershipType = "NonMember"
        membership.membershipExpiration = NSDate()
        contact.membership = membership
        
        self.saveMembership(membership)
    }
    
    func saveMembership(membership: Membership) {
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }

    func contactsOfMemberships() -> [Contact] {
        var contacts = [Contact]()
        for member in membershipLog {
            contacts.append(member.contact)
        }
        return contacts
    }
    
    // helpers for membership
    func membershipDescriptionOfContact(contact: Contact) -> String {
        return contact.membership.membershipType
    }
    
    func editMembershipTypeForContact(contact: Contact, type: MembershipType) {
        contact.membership.membershipType = type.rawValue
    }
}
