//
//  ContactLog.swift
//  SignIn
//
//  Created by Momoko Saunders on 7/5/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ContactLog: NSObject {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var allContacts : [Contact]
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
        allContacts = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do { if let fetchedResults = try managedObjectContext?.fetch(fetchRequest) as? [Contact] {
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do { if let fetchedResults = try managedObjectContext?.fetch(fetchRequest) as? [Contact] {
            allContacts = fetchedResults }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
    }
    
    func createUserWithIdentity(_ identity:String) -> Contact {
        
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedObjectContext!)
        
        let contact = Contact(entity: entity!, insertInto: managedObjectContext)
        
        //set default behaviour for contact
        contact.firstName = identity
        contact.lastName = ""
        contact.emailAddress = ""
        contact.pin = ""
        contact.colour = Colour.clear.rawValue //white value
        contact.recentUse = Date()
        contact.hasGoneThroughSetUp = false
        contact.yesOrNoQuestion = false
        
        membershipLog.createMembershipWithContact(contact)

        fetchContacts()

        saveContact(contact)
        
        return contact
    }
    
    func deleteContact(_ contact: Contact) {
        // delete the shopUses too
        ShopUseLog().deleteShopUsesForContact(contact)
        // delete membership (this should be easier)
        membershipLog.deleteMembershipForContact(contact)
        managedObjectContext?.delete(contact)

        fetchContacts()
       
        saveContact(contact)
    }
    
    func saveContact(_ contact: Contact) {
        var error: NSError?
        do {
            try managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func refreshContactMembershipData() {
        for contact in allContacts {
            if contact.membership?.membershipExpiration.timeIntervalSinceNow < 0 {
                contact.membership?.membershipType = "Non Member"
            }
        }
    }

    // Contact Filters - possibly a category

    func recentContactsWhoAreNotLoggedIn() -> [Contact] {
        var recentUsers = allContacts.sorted(by: { $0.recentUse!.timeIntervalSinceNow > $1.recentUse!.timeIntervalSinceNow})
        recentUsers.removeSubrange((0 ..< usersWhoAreLoggedIn().count))
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
    
    func currentMembers() -> [Contact] {
        var contacts = [Contact]()
        var members = [Membership]()
        let FetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Membership")
        do { if let FetchedResults = try managedObjectContext?.fetch(FetchRequest) as? [Membership] {
            members = FetchedResults }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        for member in members {
            if member.membershipExpiration.timeIntervalSinceNow > 0 {
                contacts.append(member.contact)
            }
        }
        return contacts
    }
    
    // turn data into strings
    func returnAllContactsAsCommaSeporatedString() -> String {
        var commaSeporated = "FirstName, LastName, Email Address, Yes/No (1/0), Membership" + "\r\n"
        for names in allContacts {
            commaSeporated += String("\(names.firstName!), \(names.lastName!), \(names.emailAddress!), \(names.yesOrNoQuestion), \((names.membership?.membershipType)!)" + "\r\n")
        }
        createFileWithString(commaSeporated)
        return commaSeporated
    }

    func returnAllMembersAsCommaSeporatedString() -> String {
        var commaSeporated = "FirstName, LastName, Email Address, Yes/No, Membership" + "\r\n"
        let contacts = currentMembers()
        for names in contacts {
            commaSeporated += String("\(names.firstName!), \(names.lastName!), \(names.emailAddress!), \(names.yesOrNoQuestion), \((names.membership?.membershipType)!)" + "\r\n")
        }
        createFileWithString(commaSeporated)
        return commaSeporated
    }

    func returnAllVolunteersAsCommaSeporatedString() -> String {
        var commaSeporated = "FirstName, LastName, Email Address, Yes/No, Membership" + "\r\n"
        let contacts = ShopUseLog().contactsOfVolunteer()
        for names in contacts {
            commaSeporated += String("\(names.firstName!), \(names.lastName!), \(names.emailAddress!), \(names.yesOrNoQuestion), \((names.membership?.membershipType)!)" + "\r\n")
        }
        createFileWithString(commaSeporated)
        return commaSeporated
    }
    
    func createFileWithString(_ string: String) {
        let fileName = getDocumentsDirectory().appendingPathComponent("data.csv")
        do { try string.write(toFile: fileName, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Could not create file \(error)")
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    // Helpers for turning color strings to UIColors
    
    func colourOfContact(_ contactInQuestion: Contact) -> UIColor {
        let colour = enumColourValueWithStringColour(contactInQuestion.colour!)
        var uicolor = UIColor.clear
        switch colour {
        case .purple:
            uicolor = Colors().purple
        case .blue:
            uicolor = Colors().blue
        case .green:
            uicolor = Colors().green
        case .yellow:
            uicolor = Colors().yellow
        case .orange:
            uicolor = Colors().orange
        case .red:
            uicolor = Colors().red
        case .clear:
            uicolor = UIColor.clear
        }
        return uicolor
    }
    
    func enumColourValueWithStringColour(_ colourName: String) -> Colour {
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
    
    func editColourForContact(_ contact: Contact, colour: Colour) {
        contact.colour = colour.rawValue
    }
    
    // helpers for Types 
    
    func typesUsedByContact(_ contact: Contact) -> [String] {
        var stringTypes = [String]()
        var typeArray = [Type]()
        let shopUseArray = ShopUseLog().getShopUsesForContact(contact)
        for use in shopUseArray {
            if use.type!.group! == "Contact" {
                typeArray.append(use.type!)
            }
        }
        let uniqueTypes = Array(Set(typeArray))
        let sortedTypes = uniqueTypes.sorted {Int(truncating: $0.id!) < Int($1.id!)}
        for type in sortedTypes {
            stringTypes.append(type.title!)
        }
        return stringTypes
    }
    
    func mostRecentShopUseTime(_ contact: Contact) -> Double {
        let shopUse = ShopUseLog().getMostRecentShopUseForContact(contact)
        let time = shopUse!.signIn?.timeIntervalSince(shopUse!.signOut!)
        return time!/(60*60)
    }
}
