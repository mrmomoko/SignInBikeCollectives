//
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class ShopUseLog: NSObject {

    var shopUseLog = [ShopUse]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override init(){
        let fetchRequest = NSFetchRequest(entityName: "ShopUse")
        
        var error: NSError?
        
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest,
            error: &error) as? [ShopUse]
        
        if let results = fetchedResults {
            shopUseLog = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        super.init()
    }
    func createShopUseWithContact(contact: Contact) {
        let entity = NSEntityDescription.entityForName("ShopUse", inManagedObjectContext: managedObjectContext)
        
        let shopUse = ShopUse(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)

        shopUse.signIn = NSDate()
        shopUse.signOut = NSDate().dateByAddingTimeInterval(2*60*60)

        shopUse.contact = contact
        ContactLog().saveContact(contact)

        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func createVolunteerUseWithContact(contact: Contact) {
        let entity = NSEntityDescription.entityForName("VolunteerUse", inManagedObjectContext: managedObjectContext)
        
        let volunteerUse = VolunteerUse(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        volunteerUse.signIn = NSDate()
        volunteerUse.signOut = NSDate().dateByAddingTimeInterval(2*60*60)
        
        volunteerUse.contact = contact
        ContactLog().saveContact(contact)
        
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }

    func numberOfVolunteerHoursLoggedByContact(contact: Contact) -> String {
        var totalHoursOfShopUse = 0
        for volunteerUseHour in contact.volunteer {
            var shopUseInstance = Int(volunteerUseHour.signIn.timeIntervalSinceNow - volunteerUseHour.signOut.timeIntervalSinceNow)
            shopUseInstance = shopUseInstance/60/60 * -1
            totalHoursOfShopUse = totalHoursOfShopUse + shopUseInstance
        }
        return String(totalHoursOfShopUse)
    }

    func numberOfShopUseHoursLoggedByContact(contact: Contact) -> String {
        var totalHoursOfShopUse = 0
        for shopUseHour in contact.shopUse {
            var shopUseInstance = Int(shopUseHour.signIn.timeIntervalSinceNow - shopUseHour.signOut.timeIntervalSinceNow)
            shopUseInstance = shopUseInstance/60/60 * -1
            totalHoursOfShopUse = totalHoursOfShopUse + shopUseInstance
        }
        return String(totalHoursOfShopUse)
    }
    
    func shopUsesForContact(contact: Contact) -> [ShopUse] {
        let shopUseSet = contact.shopUse
        var shopUseArray = [ShopUse]()
        for use in shopUseSet {
            shopUseArray.append(use as! ShopUse)
        }
        return shopUseArray
    }
    func contactsOfVolunteers() -> [Contact] {
        var contacts = [Contact]()
        let allContacts = ContactLog().allContacts
        for contact in allContacts {
            if contact.volunteer.count > 0 {
                 contacts.append(contact)
            }
        }
        return contacts
    }
    
    func recentShopUses() -> [ShopUse] {
        var recentUses = [ShopUse]()
        for use in shopUseLog {
            if use.signOut.timeIntervalSinceNow > -60*60 {
                recentUses.append(use)
            }
        }
        return recentUses
    }
    func recentShopUsesNotLoggedIn() -> [ShopUse] {
        var recentUsesNotLoggedIn = [ShopUse]()
        let recentUser = recentShopUses()
        for use in recentUser {
            if use.signOut.timeIntervalSinceNow < 0 {
                recentUsesNotLoggedIn.append(use)
            }
        }
        return recentUsesNotLoggedIn
    }

    func shopUsersLoggedIn() -> [ShopUse] {
        var usersLoggedIn = [ShopUse]()
        for use in shopUseLog {
            if use.signOut.timeIntervalSinceNow > -60*60 {
                usersLoggedIn.append(use)
            }
        }
        return usersLoggedIn
    }
}



//    override init() {
//        shopUseLogMaster = BCNShopUseLog.sharedStore()
//        shopUseLog = shopUseLogMaster.shopUseLog as! [ BCNShopUse ]
//        contactLog = BCNContactLog.sharedStore().contactLog as! [Contact]
//    }
//    func createShopUse() -> BCNShopUse {
//        // not sure why we need the () after createShopUse
//        // also, if I can be explicit, should I be?
//        var shopUse : BCNShopUse = shopUseLogMaster.createShopUse()
//        return shopUse
//    }
//    
//    func hoursOfVolunteeringByContact(contact: Contact, uniqueIdentifier: String) -> String {
//        var hours = iterateThroughShopUseLogForHoursOfShopUse(true, contact: contact, uniqueIdentifier: uniqueIdentifier)
//        return hours
//    }
//    
//    func hoursOfShopUseByContact(contact: Contact, uniqueIdentifier: String) -> String {
//        var hours = iterateThroughShopUseLogForHoursOfShopUse(false, contact: contact, uniqueIdentifier: uniqueIdentifier)
//        return hours
//    }
//
//    func iterateThroughShopUseLogForHoursOfShopUse(shopUseIsVolunteeringType: Bool, contact: Contact, uniqueIdentifier: String) ->String {
//        //i need to name shopUseType better
//        // should i have made this a privateFunc?
//        var contactShopUse = [BCNShopUse]()
//        var totalShopHours = 0.0
//        var previousShopHours = 0.0
//        for shopUse in shopUseLog {
//            if shopUse.volunteer == shopUseIsVolunteeringType && (shopUse.userIdentity == uniqueIdentifier || shopUse.userIdentity == contact.description || shopUse.contact == contact) {
//                contactShopUse.append(shopUse)
//            }
//        }
//        for shopUseOfContact in contactShopUse {
//            var newHours = shopUseOfContact.numberOfHoursLogged
//            totalShopHours = previousShopHours + newHours
//            previousShopHours = totalShopHours
//        }
//        let intHours = Int(totalShopHours)
//        var hours = String(intHours)
//        return hours
//
//    }
//    
//    enum Filters: String {
//        case currentMembers = "Current Members", currentShopUse = "Current Shop Use", currentVolunteers = "Current Volunteers", recentlyExpiredMembers = "Recently Expired Members", allShopUses = "All Shop Uses", allMembers = "All Members", allContacts = "All Contacts", allVolunteers = "All Volunteers", recentShopUseNotAlreadyLoggedIn = "Recent Shop Use Not Already Logged In"
//    }
//
//    func filterShopLog(incomingFilter: Filters) -> [Contact] {
//        let toBeFilteredShopUseLog = shopUseLogMaster.shopUseLog as! [ BCNShopUse ]
//        let toBeFilteredContactLog = contactLog
//        var filteredShopUseLog = [BCNShopUse]()
//        var filteredContactLog = [Contact]()
//        
//        switch incomingFilter {
//        case .currentMembers:
//            filteredContactLog = currentMembers(toBeFilteredContactLog)
//            filteredContactLog = sortContactsByName(filteredContactLog)
//        case .currentShopUse:
//            filteredShopUseLog = currentUsers(toBeFilteredShopUseLog)
//        case .currentVolunteers:
//            filteredShopUseLog = currentUsers(toBeFilteredShopUseLog)
//            filteredContactLog = pullOutVolunteers(filteredShopUseLog)
//            filteredContactLog = removeDuplicateContacts(filteredContactLog)
//        case .allVolunteers:
//            filteredContactLog = pullOutVolunteers(toBeFilteredShopUseLog)
//            filteredContactLog = removeDuplicateContacts(filteredContactLog)
//        case .recentShopUseNotAlreadyLoggedIn:
//            filteredShopUseLog = shopUsesInLast3Months(toBeFilteredShopUseLog)
//            filteredShopUseLog = pullOutCurrentUsers(filteredShopUseLog)
//            filteredContactLog = pullOutContacts(filteredShopUseLog)
//            filteredContactLog = removeDuplicateContacts(filteredContactLog)
//        default:
//            break
//        }
//        if filteredContactLog.isEmpty {
//            filteredContactLog = pullOutContacts(filteredShopUseLog)
//        }
//        return filteredContactLog
//    }
//    func shopUsesInLast3Months(shopUseArray: [BCNShopUse]) -> [BCNShopUse] {
//        var currentShopUse = [BCNShopUse]()
//        for shopUse in shopUseLog {
//            let now = NSDate().timeIntervalSince1970
//            if shopUse.signIn.timeIntervalSinceNow >= -now-60*60*24*60 {
//                currentShopUse.append(shopUse)
//            }
//        }
//        return currentShopUse
//    }
//    func currentUsers(shopUseArray: [BCNShopUse]) -> [BCNShopUse] {
//        var currentShopUse = [BCNShopUse]()
//        for shopUse in shopUseArray {
//            if shopUse.signOut.timeIntervalSinceNow >= 0 {
//                currentShopUse.append(shopUse)
//            }
//        }
//        return currentShopUse
//    }
//    func pullOutCurrentUsers(shopUseArray: [BCNShopUse]) -> [BCNShopUse] {
//        var activeUsersMinusThoseAlreadyLoggedIn = [BCNShopUse]()
//        for shopUse in shopUseArray {
//            if shopUse.signOut.timeIntervalSinceNow <= 0 {
//                activeUsersMinusThoseAlreadyLoggedIn.append(shopUse)
//            }
//        }
//        return activeUsersMinusThoseAlreadyLoggedIn
//    }
//    func currentMembers(contactArray: [Contact]) -> [Contact] {
//        var currentMembers = [Contact]()
//        for contact in contactArray {
//            if contact.membershipExpiration.timeIntervalSinceNow >= 0 {
//                currentMembers.append(contact)
//            }
//        }
//        return currentMembers
//    }
//    func sortContactsByName(contactsArray: [Contact]) -> [Contact] {
//        var contacts = contactsArray
//        contacts.sort({$0.description < $1.description})
//        return contacts
//    }
//    func pullOutContacts(shopUseArray: [BCNShopUse]) -> [Contact] {
//        var contacts = [Contact]()
//        for shopUse in shopUseArray {
//            if shopUse.contact.firstName != nil || shopUse.contact.lastName != nil || shopUse.contact.emailAddress != nil {
////                contacts.append(shopUse.contact)
//            }
//        }
//        return contacts
//    }
//    func pullOutVolunteers(shopUseArray: [BCNShopUse]) -> [Contact] {
//        var contacts = [Contact]()
//        for shopUse in shopUseArray {
//            if shopUse.contact.volunteer == true {
////                contacts.append(shopUse.contact)
//            }
//        }
//        return contacts
//    }
//    
//    func removeDuplicateContacts(contactsArray: [Contact]) -> [Contact] {
//        var listOfContactsWithOutDuplication = [Contact]()
//        var contactToCompare = Contact?()
//        for contact in contactsArray {
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
//    func activeUsersMinusThoseAlreadyLoggedIn() -> [Contact] {
//        return self.filterShopLog(Filters.recentShopUseNotAlreadyLoggedIn)
//    }
//
//    func findContactsWhichContainString(substring: String) -> [Contact] {
//        return self.filterShopLog(Filters.recentShopUseNotAlreadyLoggedIn)
//    }
////    -(NSArray *)findContactsWhichContainsString:(NSString *)substring
////    {
////    NSString *userIdentity = substring;
////    NSPredicate *filterForShopUse= [NSPredicate predicateWithFormat:@"firstName ==[c] %@ OR lastName ==[c] %@ OR pin ==[c] %@ OR emailAddress ==[c] %@", userIdentity, userIdentity, userIdentity, userIdentity];
////    NSArray *filteredVolunteerLog =
////    [[NSArray alloc] initWithArray:[[self privateContacts] filteredArrayUsingPredicate:filterForShopUse]];
////    return filteredVolunteerLog;
////    }
//
////    public func sortByLastToLogIn() -> [BCNContact] {
////        var mostRecentUsers = [BCNShopUse]()
////        var contactsOfMostRecentUsers = [BCNContact]()
////        var contactToCompare = BCNContact?()
////        for shopUse in currentUsers() {
////            if contactToCompare == nil {
////                mostRecentUsers.append(shopUse)
////                contactToCompare = shopUse.contact
////            }
////            if shopUse.contact != contactToCompare {
////                mostRecentUsers.append(shopUse)
////            }
////            contactToCompare = shopUse.contact
////        }
////        for shopUse in mostRecentUsers {
////            if shopUse.contact.firstName != nil || shopUse.contact.lastName != nil {
////                contactsOfMostRecentUsers.append(shopUse.contact)
////            }
////        }
////        return contactsOfMostRecentUsers
////    }
////    
////    public func sortContacts(contacts: [BCNContact]) -> [BCNContact] {
////        var contacts = contacts
////        var otherContacts = contacts
////        contacts.sort({ $0.description < $1.description })
////        otherContacts.sorted({ $0.description > $1.description })
////        return otherContacts
////    }
////    
////    public func contactsOfCurrentUsers() -> [BCNContact] {
////        //create an array with the most recent non-duplicateNamed shopUses
////        var currentUsersArray = currentUsers()
////        var contacts = [BCNContact]()
////        for shopUse in currentUsersArray {
////            if shopUse.contact.firstName != nil || shopUse.contact.lastName != nil {
////                contacts.append(shopUse.contact)
////            }
////        }
////        contacts = sortContacts(contacts)
////        var listOfContactsWithOutDuplication = [BCNContact]()
////        var contactToCompare = BCNContact?()
////        for contact in contacts {
////            if contactToCompare == nil {
////                listOfContactsWithOutDuplication.append(contact)
////                contactToCompare = contact
////            }
////            if contact != contactToCompare {
////                listOfContactsWithOutDuplication.append(contact)
////            }
////            contactToCompare = contact
////        }
////
////        return listOfContactsWithOutDuplication
////    }
////    public func contactsOfCurrentMemberships() -> [BCNContact] {
////        var memberContacts = [BCNContact]()
////        for contact in contactLog {
////            //check for current membership
//////            sometime the membershipExpiration is nil because of the bad data we added
////            if contact.membershipExpiration != nil && contact.membershipExpiration.timeIntervalSinceNow > 0 {
////                memberContacts.append(contact)
////            }
////        }
////        return memberContacts
////    }
//}
