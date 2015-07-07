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
    
    var fullContactLog = [NSManagedObject]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var recentUsersWhoAreNotLoggedIn: [NSManagedObject]
    
    override init() {
        recentUsersWhoAreNotLoggedIn = [NSManagedObject]()

        let fetchRequest = NSFetchRequest(entityName: "Contact")
//        let firstSortDescriptor = NSSortDescriptor(key: "shopUse.signOut", ascending: false)
//        fetchRequest.sortDescriptors = [firstSortDescriptor]
        
        var error: NSError?
        
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            recentUsersWhoAreNotLoggedIn = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        super.init()
        

//        let fetchRequest = NSFetchRequest(entityName:"Contact")

 //       var error: NSError?
//        
//        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest,
//            error: &error) as? [NSManagedObject]
//        
//        if let results = fetchedResults {
//            fullContactLog = results
//        } else {
//            println("Could not fetch \(error), \(error!.userInfo)")
//        }
//    }
    
   
    }
}
