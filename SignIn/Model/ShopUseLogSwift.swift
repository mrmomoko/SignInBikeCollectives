//
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation

public class ShopUseLogSwift: NSObject {

    public var shopUseLogMaster : BCNShopUseLog
    public var shopUseLog : [BCNShopUse]
    public var contactLog : [BCNContact]
    
    public override init() {
        shopUseLogMaster = BCNShopUseLog.sharedStore()
        shopUseLog = shopUseLogMaster.shopUseLog as! [ BCNShopUse ]
        contactLog = BCNContactLog.sharedStore().contactLog as! [BCNContact]
    }
    public func createShopUse() -> BCNShopUse {
        // not sure why we need the () after createShopUse
        // also, if I can be explicit, should I be?
        var shopUse : BCNShopUse = shopUseLogMaster.createShopUse()
        return shopUse
    }
    
    public func hoursOfVolunteeringByContact(contact: BCNContact, uniqueIdentifier: String) -> String {
        var hours = iterateThroughShopUseLogForHoursOfShopUse(true, contact: contact, uniqueIdentifier: uniqueIdentifier)
        return hours
    }
    
    public func hoursOfShopUseByContact(contact: BCNContact, uniqueIdentifier: String) -> String {
        var hours = iterateThroughShopUseLogForHoursOfShopUse(false, contact: contact, uniqueIdentifier: uniqueIdentifier)
        return hours
    }

    func iterateThroughShopUseLogForHoursOfShopUse(shopUseIsVolunteeringType: Bool, contact: BCNContact, uniqueIdentifier: String) ->String {
        //i need to name shopUseType better
        // should i have made this a privateFunc?
        var contactShopUse = [BCNShopUse]()
        var totalShopHours = 0.0
        var previousShopHours = 0.0
        for shopUse in shopUseLog {
            if shopUse.volunteer == shopUseIsVolunteeringType && (shopUse.userIdentity == uniqueIdentifier || shopUse.userIdentity == contact.description || shopUse.contact == contact) {
                contactShopUse.append(shopUse)
            }
        }
        for shopUseOfContact in contactShopUse {
            var newHours = shopUseOfContact.numberOfHoursLogged
            totalShopHours = previousShopHours + newHours
            previousShopHours = totalShopHours
        }
        let intHours = Int(totalShopHours)
        var hours = String(intHours)
        return hours

    }
    
    public enum Filters: String {
        case currentMembers = "Current Members", currentShopUse = "Current Shop Use", currentVolunteers = "Current Volunteers", recentlyExpiredMembers = "Recently Expired Members", allShopUses = "All Shop Uses", allMembers = "All Members", allContacts = "All Contacts", allVolunteers = "All Volunteers", recentShopUseNotAlreadyLoggedIn = "Recent Shop Use Not Already Logged In"
    }

    public func filterShopLog(incomingFilter: Filters) -> [BCNContact] {
        let toBeFilteredShopUseLog = shopUseLogMaster.shopUseLog as! [ BCNShopUse ]
        let toBeFilteredContactLog = contactLog
        var filteredShopUseLog = [BCNShopUse]()
        var filteredContactLog = [BCNContact]()
        
        switch incomingFilter {
        case .currentMembers:
            filteredContactLog = currentMembers(toBeFilteredContactLog)
            filteredContactLog = sortContactsByName(filteredContactLog)
        case .currentShopUse:
            filteredShopUseLog = currentUsers(toBeFilteredShopUseLog)
        case .currentVolunteers:
            filteredShopUseLog = currentUsers(toBeFilteredShopUseLog)
            filteredContactLog = pullOutVolunteers(filteredShopUseLog)
            filteredContactLog = removeDuplicateContacts(filteredContactLog)
        case .allVolunteers:
            filteredContactLog = pullOutVolunteers(toBeFilteredShopUseLog)
            filteredContactLog = removeDuplicateContacts(filteredContactLog)
        case .recentShopUseNotAlreadyLoggedIn:
            filteredShopUseLog = shopUsesInLast3Months(toBeFilteredShopUseLog)
            filteredShopUseLog = pullOutCurrentUsers(filteredShopUseLog)
            filteredContactLog = pullOutContacts(filteredShopUseLog)
            filteredContactLog = removeDuplicateContacts(filteredContactLog)
        default:
            break
        }
        if filteredContactLog.isEmpty {
            filteredContactLog = pullOutContacts(filteredShopUseLog)
        }
        return filteredContactLog
    }
    func shopUsesInLast3Months(shopUseArray: [BCNShopUse]) -> [BCNShopUse] {
        var currentShopUse = [BCNShopUse]()
        for shopUse in shopUseLog {
            let now = NSDate().timeIntervalSince1970
            if shopUse.signIn.timeIntervalSinceNow >= -now-60*60*24*60 {
                currentShopUse.append(shopUse)
            }
        }
        return currentShopUse
    }
    func currentUsers(shopUseArray: [BCNShopUse]) -> [BCNShopUse] {
        var currentShopUse = [BCNShopUse]()
        for shopUse in shopUseArray {
            if shopUse.signOut.timeIntervalSinceNow >= 0 {
                currentShopUse.append(shopUse)
            }
        }
        return currentShopUse
    }
    func pullOutCurrentUsers(shopUseArray: [BCNShopUse]) -> [BCNShopUse] {
        var activeUsersMinusThoseAlreadyLoggedIn = [BCNShopUse]()
        for shopUse in shopUseArray {
            if shopUse.signOut.timeIntervalSinceNow <= 0 {
                activeUsersMinusThoseAlreadyLoggedIn.append(shopUse)
            }
        }
        return activeUsersMinusThoseAlreadyLoggedIn
    }
    func currentMembers(contactArray: [BCNContact]) -> [BCNContact] {
        var currentMembers = [BCNContact]()
        for contact in contactArray {
            if contact.membershipExpiration.timeIntervalSinceNow >= 0 {
                currentMembers.append(contact)
            }
        }
        return currentMembers
    }
    func sortContactsByName(contactsArray: [BCNContact]) -> [BCNContact] {
        var contacts = contactsArray
        contacts.sort({$0.description < $1.description})
        return contacts
    }
    func pullOutContacts(shopUseArray: [BCNShopUse]) -> [BCNContact] {
        var contacts = [BCNContact]()
        for shopUse in shopUseArray {
            if shopUse.contact.firstName != nil || shopUse.contact.lastName != nil || shopUse.contact.emailAddress != nil {
                contacts.append(shopUse.contact)
            }
        }
        return contacts
    }
    func pullOutVolunteers(shopUseArray: [BCNShopUse]) -> [BCNContact] {
        var contacts = [BCNContact]()
        for shopUse in shopUseArray {
            if shopUse.contact.volunteer == true {
                contacts.append(shopUse.contact)
            }
        }
        return contacts
    }
    
    func removeDuplicateContacts(contactsArray: [BCNContact]) -> [BCNContact] {
        var listOfContactsWithOutDuplication = [BCNContact]()
        var contactToCompare = BCNContact?()
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
    public func activeUsersMinusThoseAlreadyLoggedIn() -> [BCNContact] {
        return self.filterShopLog(Filters.recentShopUseNotAlreadyLoggedIn)
    }

    public func findContactsWhichContainString(substring: String) -> [BCNContact] {
        return self.filterShopLog(Filters.recentShopUseNotAlreadyLoggedIn)
    }
//    -(NSArray *)findContactsWhichContainsString:(NSString *)substring
//    {
//    NSString *userIdentity = substring;
//    NSPredicate *filterForShopUse= [NSPredicate predicateWithFormat:@"firstName ==[c] %@ OR lastName ==[c] %@ OR pin ==[c] %@ OR emailAddress ==[c] %@", userIdentity, userIdentity, userIdentity, userIdentity];
//    NSArray *filteredVolunteerLog =
//    [[NSArray alloc] initWithArray:[[self privateContacts] filteredArrayUsingPredicate:filterForShopUse]];
//    return filteredVolunteerLog;
//    }

//    public func sortByLastToLogIn() -> [BCNContact] {
//        var mostRecentUsers = [BCNShopUse]()
//        var contactsOfMostRecentUsers = [BCNContact]()
//        var contactToCompare = BCNContact?()
//        for shopUse in currentUsers() {
//            if contactToCompare == nil {
//                mostRecentUsers.append(shopUse)
//                contactToCompare = shopUse.contact
//            }
//            if shopUse.contact != contactToCompare {
//                mostRecentUsers.append(shopUse)
//            }
//            contactToCompare = shopUse.contact
//        }
//        for shopUse in mostRecentUsers {
//            if shopUse.contact.firstName != nil || shopUse.contact.lastName != nil {
//                contactsOfMostRecentUsers.append(shopUse.contact)
//            }
//        }
//        return contactsOfMostRecentUsers
//    }
//    
//    public func sortContacts(contacts: [BCNContact]) -> [BCNContact] {
//        var contacts = contacts
//        var otherContacts = contacts
//        contacts.sort({ $0.description < $1.description })
//        otherContacts.sorted({ $0.description > $1.description })
//        return otherContacts
//    }
//    
//    public func contactsOfCurrentUsers() -> [BCNContact] {
//        //create an array with the most recent non-duplicateNamed shopUses
//        var currentUsersArray = currentUsers()
//        var contacts = [BCNContact]()
//        for shopUse in currentUsersArray {
//            if shopUse.contact.firstName != nil || shopUse.contact.lastName != nil {
//                contacts.append(shopUse.contact)
//            }
//        }
//        contacts = sortContacts(contacts)
//        var listOfContactsWithOutDuplication = [BCNContact]()
//        var contactToCompare = BCNContact?()
//        for contact in contacts {
//            if contactToCompare == nil {
//                listOfContactsWithOutDuplication.append(contact)
//                contactToCompare = contact
//            }
//            if contact != contactToCompare {
//                listOfContactsWithOutDuplication.append(contact)
//            }
//            contactToCompare = contact
//        }
//
//        return listOfContactsWithOutDuplication
//    }
//    public func contactsOfCurrentMemberships() -> [BCNContact] {
//        var memberContacts = [BCNContact]()
//        for contact in contactLog {
//            //check for current membership
////            sometime the membershipExpiration is nil because of the bad data we added
//            if contact.membershipExpiration != nil && contact.membershipExpiration.timeIntervalSinceNow > 0 {
//                memberContacts.append(contact)
//            }
//        }
//        return memberContacts
//    }
}
