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
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var allContacts = [Contact]()
    var allShopUses = ShopUseLog().shopUseLog
    var membershipLog = MembershipLog()
    
    enum Colour: String {
        case
        purple = "purple",
        blue = "blue",
        green = "green",
        yellow = "yellow",
        orange = "orange",
        red = "red",
        clear = "clear"
    }

    override init() {
    
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        do { if let fetchedResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Contact] {
            self.allContacts = fetchedResults }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }

        super.init()
    }
    
    func fetchContacts() {
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        do { if let fetchedResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Contact] {
            allContacts = fetchedResults }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
    }
    
    func createUserWithIdentity(identity:String) -> Contact {
        
        let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedObjectContext)
        
        let contact = Contact(entity: entity!,  insertIntoManagedObjectContext: managedObjectContext)
        
        //set default behaviour for contact
        contact.firstName = identity
        contact.lastName = ""
        contact.emailAddress = ""
        contact.pin = ""
        contact.colour = Colour.clear.rawValue //white value
        contact.recentUse = NSDate()
        
        membershipLog.createMembershipWithContact(contact)

        fetchContacts()

        saveContact(contact)
        
        return contact
    }
    
    func deleteContact(contact: Contact) {
        // delete the shopUses too
        ShopUseLog().deleteShopUsesForContact(contact)
        // delete membership (this should be easier)
        membershipLog.deleteMembershipForContact(contact)
        managedObjectContext.deleteObject(contact)

        fetchContacts()
       
        saveContact(contact)
    }
    func saveContact(contact: Contact) {
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    // Contact Filters - possibly a category

    func recentContactsWhoAreNotLoggedIn() -> [Contact] {
        var recentUsers = allContacts.sort({ $0.recentUse!.timeIntervalSinceNow > $1.recentUse!.timeIntervalSinceNow})
        recentUsers.removeRange(Range(start: 0, end: usersWhoAreLoggedIn().count))
        return recentUsers
    }
    
    func usersWhoAreLoggedIn() -> [Contact] {
        var loggedInUsers = [Contact]()
        for contact in allContacts {
            if contact.recentUse!.timeIntervalSinceNow > 0 {
                loggedInUsers.append(contact)
            }
        }
        return loggedInUsers
    }
    
    // turn data into strings
    func returnAllContactsAsCommaSeporatedString() -> String {
        var commaSeporated = "FirstName, LastName, Email Address, Yes/No, Membership" + "\r\n"
        for names in allContacts {
            commaSeporated += String("\(names.firstName!), \(names.lastName!), \(names.emailAddress!), yes, \((names.membership?.membershipType)!)" + "\r\n")
        }
        return commaSeporated
    }

    // Helpers for turning color strings to UIColors
    
    func colourOfContact(contactInQuestion: Contact) -> UIColor {
        let colour = enumColourValueWithStringColour(contactInQuestion.colour!)
        var uicolor = UIColor.clearColor()
        switch colour {
        case .purple:
            uicolor = UIColor.purpleColor()
        case .blue:
            uicolor = UIColor.cyanColor()
        case .green:
            uicolor = UIColor.greenColor()
        case .yellow:
            uicolor = UIColor.yellowColor()
        case .orange:
            uicolor = UIColor.orangeColor()
        case .red:
            uicolor = UIColor.redColor()
        case .clear:
            uicolor = UIColor.clearColor()
        }
        return uicolor
    }
    
    func enumColourValueWithStringColour(colourName: String) -> Colour {
        var colourType = Colour.clear
        if colourName == "purple" { colourType = .purple }
        else if colourName == "blue" { colourType = .blue }
        else if colourName == "green" { colourType = .green }
        else if colourName == "yellow" { colourType = .yellow }
        else if colourName == "orange" { colourType = .orange }
        else if colourName == "red" { colourType = .red }
        else if colourName == "clear" { colourType = .clear }
        return colourType
    }
    
    func editColourForContact(contact: Contact, colour: Colour) {
        contact.colour = colour.rawValue
    }
    
    func refreshContactMembershipData() {
        for contact in allContacts {
            if contact.membership?.membershipExpiration.timeIntervalSinceNow < 0 {
                contact.membership?.membershipType = "Non Member"
            }
        }
        
    }
}
