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
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var membershipLog : [Membership]

    enum MembershipType: String {
        case
        NonMember = "Non Member",
        OneMonth = "One Month",
        SixMonth = "Six Month",
        Yearly = "Yearly",
        LifeTime = "Life Time",
        Custom = "Custom"
    }
    
    override init() {
        membershipLog = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Membership")
        do { if let fetchedResults = try managedObjectContext?.fetch(fetchRequest) as? [Membership] {
            membershipLog = fetchedResults }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        super.init()
    }
    
    func createMembershipWithContact(_ contact: Contact) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Membership", in: managedObjectContext!)
        
        let membership = Membership(entity: entity!,  insertInto: managedObjectContext)
        membership.membershipType = "NonMember"
        membership.membershipExpiration = Date()
        contact.membership = membership
        
        self.saveMembership(membership)
    }
    
    func saveMembership(_ membership: Membership) {
        var error: NSError?
        do {
            try managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(String(describing: error)), \(String(describing: error?.userInfo))")
        }
    }

    func deleteMembershipForContact(_ contact: Contact) {
        managedObjectContext?.delete(contact.membership!)
    }
    
    // helpers for membership
    func membershipDescriptionOfContact(_ contact: Contact) -> String {
        return contact.membership!.membershipType
    }
    
    func editMembershipTypeForContact(_ contact: Contact, type: String) {
        contact.membership!.membershipType = type
        let membershipExpiration = Date(timeInterval: timeIntervalForMembershipType(type), since: Date())
        contact.membership!.membershipExpiration = membershipExpiration
    }
    
    func timeIntervalForMembershipType(_ type: String) -> TimeInterval {
        var time = TimeInterval()
        switch type {
        case MembershipType.NonMember.rawValue:
            time = 0.0
        case MembershipType.OneMonth.rawValue:
            time = 60*60*24*31
        case MembershipType.SixMonth.rawValue:
            time = 60*60*24*183
        case MembershipType.Yearly.rawValue:
            time = 60*60*24*365
        case MembershipType.LifeTime.rawValue:
            time = 60*60*24*365*100
        case MembershipType.Custom.rawValue:
            // TODO: this isn't an appropriate way to determine custom
            time = 60*60*24*365*100
        default:
            time = 0.0
        }
        return time
    }
    
    func membershipExperationDate(_ contact: Contact) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // superset of OP's format
        let membershipExperationDate = dateFormatter.string(from: contact.membership!.membershipExpiration as Date)
        return membershipExperationDate
    }
}
