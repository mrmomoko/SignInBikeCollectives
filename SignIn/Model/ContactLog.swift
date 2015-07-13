//
//  ContactLog.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/5/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreData

class ContactLog: NSObject {
    
    var fullContactLog = [Contact]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var recentUsersWhoAreNotLoggedIn: [Contact]
    
    override init() {
        recentUsersWhoAreNotLoggedIn = [Contact]()

        let fetchRequest = NSFetchRequest(entityName: "Contact")
//        let firstSortDescriptor = NSSortDescriptor(key: "shopUse.signOut", ascending: false)
//        fetchRequest.sortDescriptors = [firstSortDescriptor]
        
        var error: NSError?
        
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest,
            error: &error) as? [Contact]
        
        if let results = fetchedResults {
            recentUsersWhoAreNotLoggedIn = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        super.init()
        
    }
    func createUserWithIdentity(identity:String) -> Contact {
        
        let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedObjectContext)
        
        
        let contact = Contact(entity: entity!,  insertIntoManagedObjectContext: managedObjectContext)
        
        //set default behaviour for contact
        contact.firstName = ""
        contact.lastName = ""
        contact.emailAddress = ""
        contact.pin = ""
//        contact.membership = Membership.membershipType(rawValue: mem))
        contact.colour = 6 //white value

        //save new stuff
        contact.firstName = identity
        
        self.saveContact(contact)
        
        return contact
    }
    
    func saveContact(contact: Contact) {
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        fullContactLog.append(contact)
    }
}
