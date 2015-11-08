//
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class ShopUseLog: NSObject {

    var shopUseLog = [ShopUse]()
    var volunteerLog = [VolunteerUse]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override init(){
        let fetchRequest = NSFetchRequest(entityName: "ShopUse")
        
        do { if let fetchedResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [ShopUse] {
                shopUseLog = fetchedResults}
            else {
              assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        let volunteerFetchRequest = NSFetchRequest(entityName: "VolunteerUse")
        
        do { if let volunteerFetchedResults = try managedObjectContext.executeFetchRequest(volunteerFetchRequest) as? [VolunteerUse] {
            volunteerLog = volunteerFetchedResults }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }

        super.init()
    }
    
    func deleteShopUsesForContact(contact: Contact) {
        for shopUse in contact.shopUse! {
            managedObjectContext.deleteObject(shopUse as! NSManagedObject)
        }
    }
    
    func deleteSignalShopUse(shopUse: AnyObject) {
        managedObjectContext.deleteObject(shopUse as! NSManagedObject)
    }
    
    func createShopUseWithContact(contact: Contact) {
        let entity = NSEntityDescription.entityForName("ShopUse", inManagedObjectContext: managedObjectContext)
        
        let shopUse = ShopUse(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)

        shopUse.signIn = NSDate()
        shopUse.signOut = NSDate().dateByAddingTimeInterval(2*60*60)

        shopUse.contact = contact
        shopUse.contact.recentUse = shopUse.signOut
        shopUse.contact.recentUseType = "shopUse"
        ContactLog().saveContact(contact)

        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func createVolunteerUseWithContact(contact: Contact) {
        let entity = NSEntityDescription.entityForName("VolunteerUse", inManagedObjectContext: managedObjectContext)
        
        let volunteerUse = VolunteerUse(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        volunteerUse.signIn = NSDate()
        volunteerUse.signOut = NSDate().dateByAddingTimeInterval(2*60*60)
        
        volunteerUse.contact = contact
        volunteerUse.contact.recentUse = volunteerUse.signOut
        volunteerUse.contact.recentUseType = "volunteerUse"
        ContactLog().saveContact(contact)
        
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }

    func signOutContact(contact: Contact) {
        // Get the most recent shopUse
        if contact.recentUseType == "volunteerUse" {
            // Set the signOut to now
            let use = ShopUseLog().getMostRecentShopUseForContact(contact) as! VolunteerUse
            use.signOut = NSDate()
        } else {
            let use = ShopUseLog().getMostRecentShopUseForContact(contact) as! ShopUse
            // Set the signOut to now
            use.signOut = NSDate()
        }
        // reset the recentUse time
        contact.recentUse = NSDate()
    }
    
    func findMostRecentShopUseForContact(contact: Contact) -> ShopUse {
        var log = []
        let recentUseFetchRequest = NSFetchRequest(entityName: "ShopUse")
        let predicate = NSPredicate(format: "contact == %@ && signOut > NSDate", contact)
        //let sortDescriptor
        //set fetch limit, so that the fetch request only returns one.
        recentUseFetchRequest.predicate = predicate
        do { if let recentUseFetch = try managedObjectContext.executeFetchRequest(recentUseFetchRequest) as? [ShopUse] {
            log =  recentUseFetch}
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return log.firstObject! as! ShopUse
    }
    
    func getMostRecentShopUseForContact(contact: Contact) -> AnyObject {
        var log = []
        if contact.recentUseType == "volunteerUse" {
            let volunteerFetchRequest = NSFetchRequest(entityName: "VolunteerUse")
            let predicate = NSPredicate(format: "signOut == %@", contact.recentUse!)
            volunteerFetchRequest.predicate = predicate
            do { if let volunteerFetchedResults = try managedObjectContext.executeFetchRequest(volunteerFetchRequest) as? [VolunteerUse] {
                 log = volunteerFetchedResults }
            else {
                assertionFailure("Could not executeFetchRequest")
                }
            } catch let error as NSError {
                print("Could not fetch \(error)")
            }
        } else if contact.recentUseType == "shopUse" {
            let FetchRequest = NSFetchRequest(entityName: "ShopUse")
            let predicate = NSPredicate(format: "signOut == %@", contact.recentUse!)
            FetchRequest.predicate = predicate
            do { if let FetchedResults = try managedObjectContext.executeFetchRequest(FetchRequest) as? [ShopUse] {
                log = FetchedResults }
            else {
                assertionFailure("Could not executeFetchRequest")
                }
            } catch let error as NSError {
                print("Could not fetch \(error)")
            }
        }
        return log[0]
    }
    
    func loggedInContacts() -> [Contact] {
        let loggedInContacts = ContactLog().allContacts
        var newContacts = [Contact]()
        for user in loggedInContacts {
            if user.recentUse!.timeIntervalSinceNow > 0 {
                newContacts.append(user)
            }
        }
        return newContacts
    }

    func numberOfVolunteerHoursLoggedByContact(contact: Contact) -> String {
        var totalHoursOfShopUse = 0
        for volunteerUseHour in contact.volunteer! {
            let shopUseInstance = Int(volunteerUseHour.signIn.timeIntervalSinceNow - volunteerUseHour.signOut.timeIntervalSinceNow)
            totalHoursOfShopUse = totalHoursOfShopUse + shopUseInstance
        }
        totalHoursOfShopUse = totalHoursOfShopUse/(60 * 60) * -1

        return String(totalHoursOfShopUse)
    }

    func numberOfShopUseHoursLoggedByContact(contact: Contact) -> String {
        var totalHoursOfShopUse = 0
        for shopUseHour in contact.shopUse! {
            var shopUseInstance = Int(shopUseHour.signIn.timeIntervalSinceNow - shopUseHour.signOut.timeIntervalSinceNow)
            shopUseInstance = shopUseInstance/(60 * 60) * -1
            totalHoursOfShopUse = totalHoursOfShopUse + shopUseInstance
        }
        return String(totalHoursOfShopUse)
    }
    
    func hourlyTotalForThisMonth(contact: Contact) -> String {
        var hourlyTotalForThisMonth = 0
        for shopUseHour in contact.shopUse! {
            if isDateInThisMonth(shopUseHour.signIn) {
                var shopUseInstance = Int(shopUseHour.signIn.timeIntervalSinceNow - shopUseHour.signOut.timeIntervalSinceNow)
                shopUseInstance = shopUseInstance/(60 * 60) * -1
                hourlyTotalForThisMonth = hourlyTotalForThisMonth + shopUseInstance
            }
        }
        return String(hourlyTotalForThisMonth)
    }
    
    func hourlyTotalForLastMonth(contact: Contact) -> String {
        var hourlyTotalForThisMonth = 0
        for shopUseHour in contact.shopUse! {
            if isDateInLastMonth(shopUseHour.signIn) {
                var shopUseInstance = Int(shopUseHour.signIn.timeIntervalSinceNow - shopUseHour.signOut.timeIntervalSinceNow)
                shopUseInstance = shopUseInstance/(60 * 60) * -1
                hourlyTotalForThisMonth = hourlyTotalForThisMonth + shopUseInstance
            }
        }
        return String(hourlyTotalForThisMonth)
    }
    
    func hourlyVolunteerTotalForThisMonth(contact: Contact) -> String {
        var hourlyTotalForThisMonth = 0
        for shopUseHour in contact.volunteer! {
            if isDateInThisMonth(shopUseHour.signIn) {
                var shopUseInstance = Int(shopUseHour.signIn.timeIntervalSinceNow - shopUseHour.signOut.timeIntervalSinceNow)
                shopUseInstance = shopUseInstance/(60 * 60) * -1
                hourlyTotalForThisMonth = hourlyTotalForThisMonth + shopUseInstance
            }
        }
        return String(hourlyTotalForThisMonth)
    }
    
    func hourlyVolunteerTotalForLastMonth(contact: Contact) -> String {
        var hourlyTotalForThisMonth = 0
        for shopUseHour in contact.volunteer! {
            if isDateInLastMonth(shopUseHour.signIn) {
                var shopUseInstance = Int(shopUseHour.signIn.timeIntervalSinceNow - shopUseHour.signOut.timeIntervalSinceNow)
                shopUseInstance = shopUseInstance/(60 * 60) * -1
                hourlyTotalForThisMonth = hourlyTotalForThisMonth + shopUseInstance
            }
        }
        return String(hourlyTotalForThisMonth)
    }

    func isDateInThisMonth(date: NSDate) -> Bool {
        var bool = true
        let calendar = NSCalendar.currentCalendar()
        let thisMonth = calendar.component(.Month, fromDate: NSDate())
        let dateComponets = calendar.component(.Month, fromDate: date)
        if thisMonth == dateComponets {
            bool = true
        } else {
            bool = false
        }
        return bool
    }
    
    func isDateInLastMonth(date: NSDate) -> Bool {
        var bool = true
        let calendar = NSCalendar.currentCalendar()
        let thisMonth = calendar.component(.Month, fromDate: NSDate()) - 1
        let dateComponets = calendar.component(.Month, fromDate: date)
        if thisMonth == dateComponets {
            bool = true
        } else {
            bool = false
        }
        return bool
    }

    func shopUsesForContact(contact: Contact) -> [ShopUse] {
        let shopUseSet = contact.shopUse
        var shopUseArray = [ShopUse]()
        for use in shopUseSet! {
            shopUseArray.append(use as! ShopUse)
        }
        return shopUseArray
    }
    
    func volunteerUsesForContact(contact: Contact) -> [VolunteerUse] {
        let shopUseSet = contact.volunteer
        var shopUseArray = [VolunteerUse]()
        for use in shopUseSet! {
            shopUseArray.append(use as! VolunteerUse)
        }
        return shopUseArray
    }

    func contactsOfVolunteers() -> [Contact] {
        var contacts = [Contact]()
        let allContacts = ContactLog().allContacts
        for contact in allContacts {
            if contact.volunteer!.count > 0 {
                 contacts.append(contact)
            }
        }
        return contacts
    }
}
