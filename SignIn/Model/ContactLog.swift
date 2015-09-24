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
    var allContacts : [Contact]
    var allShopUses : [ShopUse]
    
//    enum MembershipType: String {
//        case
//        NonMember = "Non Member",
//        Monthly = "Monthly",
//        SixMonth = "6 Month",
//        Yearly = "Yearly",
//        LifeTime = "Life Time"
//    }
    
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
        allContacts = [Contact]()
        allShopUses = ShopUseLog().shopUseLog
    
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
        
        MembershipLog().createMembershipWithContact(contact)
        
        return contact
    }
    func deleteContact(contact: Contact) {
        // delete the shopUses too
        ShopUseLog().deleteShopUsesForContact(contact)
        // delete membership (this should be easier)
        MembershipLog().deleteMembershipForContact(contact)
        managedObjectContext.deleteObject(contact)
       
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
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
        var recentUsers = allContacts.sort({ $0.recentUse.timeIntervalSinceNow > $1.recentUse.timeIntervalSinceNow})
        recentUsers.removeRange(Range(start: 0, end: usersWhoAreLoggedIn().count))
        return recentUsers
    }
    
    func usersWhoAreLoggedIn() -> [Contact] {
        var loggedInUsers = [Contact]()
        for contact in allContacts {
            if contact.recentUse.timeIntervalSinceNow > 0 {
                loggedInUsers.append(contact)
            }
        }
        return loggedInUsers
    }

    // Helpers for turning color strings to UIColors
    
    func colourOfContact(contactInQuestion: Contact) -> UIColor {
        let colour = enumColourValueWithStringColour(contactInQuestion.colour)
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
        default:
            break
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
    
    // helpers for filters
    func removeDuplicateContacts(var contactsArray: [Contact]) -> [Contact] {
        var listOfContactsWithOutDuplication = [Contact]()
        var contactToCompare = Contact?()
        
        contactsArray = contactsArray.sort({ $0.firstName < $1.firstName })
        
        for contact in contactsArray {
            if contactToCompare == nil {
                listOfContactsWithOutDuplication.append(contact)
                contactToCompare = contact
            }
            // all contacts are not equal to each other :(
            // must be in order for this to work...
            if contactIsEqualToContact(contact, otherContact: contactToCompare!) == false {
                listOfContactsWithOutDuplication.append(contact)
            }
            contactToCompare = contact
        }

        return listOfContactsWithOutDuplication
    }
    func pullOutContacts(shopUseArray: [ShopUse]) -> [Contact] {
        var contacts = [Contact]()
        for shopUse in shopUseArray {
            if shopUse.contact.firstName != "" || shopUse.contact.lastName != "" || shopUse.contact.emailAddress != "" {
                contacts.append(shopUse.contact)
            }
        }
        return contacts
    }
    
    func pullOutContactsFromVolunteerLog(shopUseArray: [VolunteerUse]) -> [Contact] {
        var contacts = [Contact]()
        for shopUse in shopUseArray {
            if shopUse.contact.firstName != "" || shopUse.contact.lastName != "" || shopUse.contact.emailAddress != "" {
                contacts.append(shopUse.contact)
            }
        }
        return contacts
    }
    
    func contactIsEqualToContact(contact: Contact, otherContact: Contact) -> Bool {
        return contact.firstName == otherContact.firstName && contact.lastName == otherContact.lastName && contact.emailAddress == contact.emailAddress
    }

}
