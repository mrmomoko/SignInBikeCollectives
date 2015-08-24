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
    
    enum MembershipType: String {
        case
        NonMember = "Non Member",
        Monthly = "Monthly",
        SixMonth = "6 Month",
        Yearly = "Yearly",
        LifeTime = "Life Time"
    }
    
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
        var error: NSError?
        
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest,
            error: &error) as? [Contact]
        
        if let results = fetchedResults {
            allContacts = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        super.init()
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
        
        return contact
    }
    
    func saveContact(contact: Contact) {
        if contact.firstName != "" && contact.lastName != "" && contact.emailAddress != "" {
            var error: NSError?
            if !managedObjectContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
    }
    
    // Contact Filters - possibly a category

    func recentContactsWhoAreNotLoggedIn() -> [Contact] {
        var recentUsers = [Contact]()
        let recentShopLog = ShopUseLog().recentShopUsesNotLoggedIn()
        let recentVolunteerLog = ShopUseLog().recentVolunteerUsesNotLoggedIn()
        recentUsers = pullOutContacts(recentShopLog)
        recentUsers = recentUsers + pullOutContactsFromVolunteerLog(recentVolunteerLog)
        recentUsers = removeDuplicateContacts(recentUsers)
        return recentUsers
    }
    
    func usersWhoAreLoggedIn() -> [Contact] {
        var loggedInUsers = [Contact]()
        let shopUsesForLoggedInContacts = ShopUseLog().shopUsersLoggedIn()
        let recentVolunteerLog = ShopUseLog().volunteerUsersLoggedIn()
        loggedInUsers = pullOutContacts(shopUsesForLoggedInContacts)
        loggedInUsers = loggedInUsers + pullOutContactsFromVolunteerLog(recentVolunteerLog)
        loggedInUsers = removeDuplicateContacts(loggedInUsers)
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
        if colourName == "blue" { colourType = .blue }
        if colourName == "green" { colourType = .green }
        if colourName == "yellow" { colourType = .yellow }
        if colourName == "orange" { colourType = .orange }
        if colourName == "red" { colourType = .red }
        if colourName == "clear" { colourType = .clear }
        return colourType
    }
    
    func editColourForContact(contact: Contact, colour: Colour) {
        contact.colour = colour.rawValue
    }
    
    // helpers for filters
    
    func removeDuplicateContacts(contactsArray: [Contact]) -> [Contact] {
        var listOfContactsWithOutDuplication = [Contact]()
        var contactToCompare = Contact?()
        for contact in contactsArray {
            if contactToCompare == nil {
                listOfContactsWithOutDuplication.append(contact)
                contactToCompare = contact
            }
            if contact != contactToCompare {
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

}
