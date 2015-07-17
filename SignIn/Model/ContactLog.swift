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
        contact.membershipExpiration = NSDate()
        contact.membership.membershipType = MembershipType.NonMember.rawValue
        contact.colour = Colour.clear.rawValue //white value

        //save new stuff
        contact.firstName = identity
        
 //       self.saveContact(contact)
        
        return contact
    }
    
    func saveContact(contact: Contact) {
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        fullContactLog.append(contact)
    }
    
//    func membershipDescriptionOfContact(contact: Contact) -> String {
//        return contact.membership.membershipType
//    }
    
    func editMembershipTypeForContact(contact: Contact, type: MembershipType) {
        contact.membership.membershipType = type.rawValue
    }
    
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
}
