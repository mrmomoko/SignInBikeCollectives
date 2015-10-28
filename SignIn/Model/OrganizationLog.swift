//
//  OrganizationLog.swift
//  SignIn
//
//  Created by Momoko Saunders on 10/20/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class  OrganizationLog: NSObject {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var organizationLog : [Organization]
    
    override init() {
        organizationLog = []
        super.init()
        let fetchRequest = NSFetchRequest(entityName: "Organization")
        do { if let fetchedResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Organization] {
            organizationLog = fetchedResults
        }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
    }
    
    func createOrganizationWithDefaultValues() {
        let entity = NSEntityDescription.entityForName("Organization", inManagedObjectContext: managedObjectContext)
        
        let org = Organization(entity: entity!,  insertIntoManagedObjectContext: managedObjectContext)
        
        //set default behaviour for organization
        org.defaultSignOutTime = 4
        org.userTypes = UserTypes()
        //create UserTypes?

        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func currentOrganization() -> (organization:Organization?, doesTheOrgExist:Bool) {
        let org : Organization
        if organizationLog.count > 0 {
            org = organizationLog.first!
            return (org, true)
        } else {
            return (nil, false)
        }
    }
    
    func deleteOrg(org: Organization) {
        managedObjectContext.deleteObject(org)
        
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func saveOrg(org: Organization) {
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
}
