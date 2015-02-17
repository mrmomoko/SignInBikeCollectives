//
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation

// do i really want public? I'm only doing this cause rocketmiles did
public class ShopUseLogSwift: NSObject {

    public var shopUseLogMaster : BCNShopUseLog
    public var shopUseLog = [BCNShopUse]()
    
    public override init() {
        shopUseLogMaster = BCNShopUseLog.sharedStore()
        shopUseLog = shopUseLogMaster.shopUseLog as [BCNShopUse]
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
    
    public func currentUsers() -> [BCNShopUse] {
        // who is using the shop?
        var currentShopUse = [BCNShopUse]()
        for shopUse in shopUseLog {
            let now = NSDate().timeIntervalSince1970
            if shopUse.signIn.timeIntervalSinceNow >= -now-60*60*24*60 {
                currentShopUse.append(shopUse)
            }
        }
        return currentShopUse
    }
    
    public func mostRecentUsersWhoAreNotCurrentlyInTheShop() -> [BCNShopUse] {
        var mostRecentUsers = shopUseLog
        // show me contacts who have logged in in the last month and are not currently in the shop
        
        return mostRecentUsers
    }
    
    public func contactsOfCurrentUsers() -> [BCNContact] {
        //create an array with the most recent non-duplicateNamed shopUses
        var currentUsersArray = currentUsers()
        var contacts = [BCNContact]()
        for shopUse in currentUsersArray {
            contacts.append(shopUse.contact)
        }
        var listOfContactsWithOutDuplication = [BCNContact]()
        for contact in contacts {
            for singleInstancesOfContacts in listOfContactsWithOutDuplication {
                if contact != singleInstancesOfContacts {
                    listOfContactsWithOutDuplication.append(contact)
                }
            }
        }

        return listOfContactsWithOutDuplication
    }
    public func currentShopUsesWithOutDuplication() -> [BCNShopUse] {
        var currentUsersArray = currentUsers()
        var copyArray = currentUsers()
        var finalArray = currentUsers()

        for shopUse in currentUsersArray {
            for copyShopUse in copyArray {
                if shopUse.contact == copyShopUse.contact &&  shopUse.timeStamp != copyShopUse.timeStamp {
//                    finalArray.removeAtIndex(find(copyArray, copyShopUse)!)
                }
            }
        }
        return finalArray
    }
}
