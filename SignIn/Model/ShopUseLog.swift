//
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ShopUseLog: NSObject {

    var shopUseLog : [ShopUse]
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    override init(){
        shopUseLog = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShopUse")
        
        do { if let fetchedResults = try managedObjectContext?.fetch(fetchRequest) as? [ShopUse] {
                shopUseLog = fetchedResults}
            else {
              assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        super.init()
    }
    
    func deleteShopUsesForContact(_ contact: Contact) {
        for shopUse in contact.shopUse! {
            managedObjectContext?.delete(shopUse as! NSManagedObject)
        }
    }
    
    func deleteSignalShopUse(_ shopUse: ShopUse) {
        managedObjectContext?.delete(shopUse as NSManagedObject)
    }
    
    func createShopUseWithContact(_ contact: Contact, id: Int) {
        let entity = NSEntityDescription.entity(forEntityName: "ShopUse", in: managedObjectContext!)
        
        let shopUse = ShopUse(entity: entity!, insertInto: managedObjectContext)

        shopUse.signIn = Date()
        let org = OrganizationLog().organizationLog.first
        let autoLogOut = TimeInterval(truncating: (org!.defaultSignOutTime)!)
        shopUse.signOut = Date().addingTimeInterval(60*60*autoLogOut)
        shopUse.type = TypeLog().getType(id)

        shopUse.contact = contact
        shopUse.contact!.recentUse = shopUse.signOut
        ContactLog().saveContact(contact)

        var error: NSError?
        do {
            try managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func getShopUseLog() -> [ShopUse] {
        shopUseLog = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShopUse")
        
        do { if let fetchedResults = try managedObjectContext?.fetch(fetchRequest) as? [ShopUse] {
            shopUseLog = fetchedResults}
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return shopUseLog
    }
    
    func signOutContact(_ contact: Contact) {
        // Get the most recent shopUse if there is one
        if let use = ShopUseLog().getMostRecentShopUseForContact(contact) {
            // Set the signOut to now
            use.signOut = Date()
            // reset the recentUse time
            contact.recentUse = use.signOut
        }
    }

    func getShopUsesForContact(_ contact: Contact) -> [ShopUse] {
        var log = [ShopUse]()
        let FetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShopUse")
        let predicate = NSPredicate(format: "contact == %@", contact)
        FetchRequest.predicate = predicate
        do { if let FetchedResults = try managedObjectContext?.fetch(FetchRequest) as? [ShopUse] {
            log = FetchedResults }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return log
    }
    
    func getMostRecentShopUseForContact(_ contact: Contact) -> ShopUse? {
        var log = getShopUsesForContact(contact)
        if log.count < 1 {
            // if somehow, there are no shopUses for the contact, 
            // then create one, and make note of this!
            createShopUseWithContact(contact, id: 1)
        }
        log.sort(by: { $0.signIn!.timeIntervalSinceNow > $1.signIn!.timeIntervalSinceNow})
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
    
    func timeOfCurrentShopUseForContact(_ contact: Contact) -> String {
        let recentUse = getMostRecentShopUseForContact(contact)
        let signIn = -1 * recentUse!.signIn!.timeIntervalSinceNow/(60*60)
        var mySubString = ""
        if recentUse?.signOut!.timeIntervalSinceNow > 0 {
            mySubString = String(format: "%.1f", signIn)
        }
        return mySubString
    }
    
    func numberOfHoursLoggedByContact(_ contact: Contact, typeTitle: String) -> String {
        var totalHoursOfShopUse = 0.0
        
        //get all the shopUses of a certian type
        // the sign in will be a large negative number
        // the signout will be a slightly smaller negative number, unless the user is not logged out, then it will be a positive number
        //subtract the signIn from the sign in
        
        // maybe i should first determin if they are logged in or out?
        // if out, then it's simple. 
        // if in, we have to remove the most recent shop use from the equation, 
        // in the past, i subtracted the total, then added back the current time,
        
        // but what happens when you're logged in, and you log out, and then you log back in as a different type, it shows up negative.
        
        // how can I know the request is for the hourly time is for the type that the user is logged in for?
        for shopUseHour in contact.shopUse! {
            if (shopUseHour as AnyObject).type!!.title! == typeTitle {
                let shopUseInstance = timeIntervalBetweenTwoDates((shopUseHour as AnyObject).signIn!! as Date,date2:  (shopUseHour as AnyObject).signOut!! as Date)
                totalHoursOfShopUse = totalHoursOfShopUse + shopUseInstance
            }
        }
        
        totalHoursOfShopUse = totalHoursOfShopUse/(60*60)

        // if user is logged in
        if contact.recentUse?.timeIntervalSinceNow > 0 {
            let lastShopUse = getMostRecentShopUseForContact(contact)
            if typeTitle == lastShopUse?.type?.title {
            let totalTimeOfLastShopUse = timeIntervalBetweenTwoDates((lastShopUse?.signIn)! as Date, date2: (lastShopUse?.signOut)! as Date)/(60*60)
            totalHoursOfShopUse = totalHoursOfShopUse - totalTimeOfLastShopUse + Double(timeOfCurrentShopUseForContact(contact))!
            }
        }
        return String(format: "%.1f", totalHoursOfShopUse)
   }

    func timeIntervalBetweenTwoDates(_ date1: Date, date2: Date) -> Double {
        return Double(-1 * date1.timeIntervalSinceNow + date2.timeIntervalSinceNow)
    }

    func hourlyTotalForThisMonth(_ contact: Contact, typeTitle: String) -> String {
        var totalHoursOfShopUse = 0.0
        for shopUseHour in contact.shopUse! {
            if isDateInThisMonth((shopUseHour as AnyObject).signIn!! as Date) && (shopUseHour as AnyObject).type!!.title == typeTitle {
                let shopUseInstance = timeIntervalBetweenTwoDates((shopUseHour as AnyObject).signIn!! as Date,date2:  (shopUseHour as AnyObject).signOut!! as Date)
                totalHoursOfShopUse = totalHoursOfShopUse + shopUseInstance
            }
        }
        
        totalHoursOfShopUse = totalHoursOfShopUse/(60*60)
        
        // if user is logged in
        if contact.recentUse?.timeIntervalSinceNow > 0 {
            let lastShopUse = getMostRecentShopUseForContact(contact)
            if typeTitle == lastShopUse?.type?.title {
            let totalTimeOfLastShopUse = timeIntervalBetweenTwoDates((lastShopUse?.signIn)! as Date, date2: (lastShopUse?.signOut)! as Date)/(60*60)
            let time = Double(timeOfCurrentShopUseForContact(contact))!
            totalHoursOfShopUse = totalHoursOfShopUse - totalTimeOfLastShopUse + time
            }
        }
        return String(format: "%.1f", totalHoursOfShopUse)
    }
    
    func hourlyTotalForLastMonth(_ contact: Contact, typeTitle: String) -> String {
        var hourlyTotalForThisMonth = 0.0
        for shopUseHour in contact.shopUse! {
            if isDateInLastMonth((shopUseHour as AnyObject).signIn!! as Date) && (shopUseHour as AnyObject).type!!.title == typeTitle {
                var shopUseInstance = Double((shopUseHour as AnyObject).signIn!!.timeIntervalSinceNow - (shopUseHour as AnyObject).signOut!!.timeIntervalSinceNow)
                shopUseInstance = shopUseInstance/(60 * 60) * -1
                hourlyTotalForThisMonth = hourlyTotalForThisMonth + shopUseInstance
            }
        }
        return String(format: "%.1f", hourlyTotalForThisMonth)
    }

//    func formateNumberTo3Characters(number: Double) -> String {
//        let array = [Character](string.characters)
//        let mySubString = String("\(array[0])\(array[1])\(array[2])")
//        return mySubString
//    }
    
    func isDateInThisMonth(_ date: Date) -> Bool {
        var bool = true
        let calendar = Calendar.current
        let thisMonth = (calendar as NSCalendar).component(.month, from: Date())
        let dateComponets = (calendar as NSCalendar).component(.month, from: date)
        if thisMonth == dateComponets {
            bool = true
        } else {
            bool = false
        }
        return bool
    }
    
    func isDateInLastMonth(_ date: Date) -> Bool {
        var bool = true
        let calendar = Calendar.current
        let thisMonth = (calendar as NSCalendar).component(.month, from: Date()) - 1
        let dateComponets = (calendar as NSCalendar).component(.month, from: date)
        if thisMonth == dateComponets {
            bool = true
        } else {
            bool = false
        }
        return bool
    }
    
//    func contactsOfVolunteers() -> [Contact] {
//        var contacts = [Contact]()
//        // this is ugly, can i make it better?
//        // fetchrequest! nope, that's worse
//        let allContacts = ContactLog().allContacts
//        // creates duplicates...
//        for contact in allContacts {
//            if contact.shopUse!.count > 0 {
//                for use in contact.shopUse! {
//                    if use.type!!.title! == "Volunteer" {
//                        contacts.append(contact)
//                    }
//                }
//            }
//        }
//        return contacts
//    }
    
    func contactsOfVolunteer() -> [Contact] {
        var contacts = [Contact]()
        var shopUseArray = [ShopUse]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShopUse")
        let predicateVolunteerType = NSPredicate(format: "type == %@", TypeLog().getType(1))
        fetchRequest.predicate = predicateVolunteerType
        
        do { if let fetchedResults = try managedObjectContext?.fetch(fetchRequest) as? [ShopUse] {
            shopUseArray = fetchedResults}
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        for use in shopUseArray {
            contacts.append(use.contact!)
        }
        let unique = Array(Set(contacts))
        
         return unique
    }
    
    func shopUseLogAsCommaSeporatedString() -> String {
        var stringData = "SignIn,, SignOut,, Contact First Name, Last Name, Type"  + "\r\n"
        let dateFormator = DateFormatter()
        dateFormator.dateStyle = .short
        dateFormator.timeStyle = .short
        for use in getShopUseLog() {
            if let firstName = use.contact?.firstName!, let lastName = use.contact?.lastName!, let type = use.type?.title! {
            stringData += String("\(dateFormator.string(from: use.signIn! as Date)), \(dateFormator.string(from: use.signOut! as Date)), \(firstName), \(lastName), \((type))" + "\r\n")
            }
        }
        let fileName = getDocumentsDirectory().appendingPathComponent("data.csv")
        do { try stringData.write(toFile: fileName, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Could not create file \(error)")
        }
        return stringData
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
}
