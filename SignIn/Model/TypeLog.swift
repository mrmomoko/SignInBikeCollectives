//
//  TypeLog.swift
//  SignIn
//
//  Created by Momoko Saunders on 11/29/15.
//  Copyright © 2015 Momoko Saunders. All rights reserved.
//

import Foundation

class TypeLog: NSObject {

    var typeLog : [Type]
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override init() {
        typeLog = []
        let fetchRequest = NSFetchRequest(entityName: "Type")
        do { if let fetchedResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Type] {
            typeLog = fetchedResults }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        super.init()
    }
    
    func addType(title: String) {
        if isDupicateType(title) == false {
        let entity = NSEntityDescription.entityForName("Type", inManagedObjectContext: managedObjectContext)
        
        let type = Type(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        type.title = title
        type.active = NSNumber.init(bool:true)
        type.organization = OrganizationLog().currentOrganization().organization!
        //set default behaviour for organization
        
        saveType()
        }
    }
    
    func getType(title: String) -> Type {
        // not sure if I should do this check, if it doesn't exist in the log,
        // maybe I shouldn't be able to get it
        if isDupicateType(title) == false {
            addType(title)
        }
        let fetchRequest = NSFetchRequest(entityName: "Type")
        let predicate = NSPredicate(format: "title == %@", title)
        var type = [Type]()
        fetchRequest.predicate = predicate
        do { if let fetchedResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Type] {
            type = fetchedResults }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return type.first!
    }
    
    func isDupicateType(title: String) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Type")
        let predicate = NSPredicate(format: "title == %@", title)
        var type = [Type]()
        fetchRequest.predicate = predicate
        do { if let fetchedResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Type] {
            type = fetchedResults }
        else {
            assertionFailure("Could not executeFetchRequest")
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        if type.count > 0 {//then we have already have that type
            return true
        } else {
            return false
        }
    }
    
    func saveType() {
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func deleteType(type: String) {
        
    }
    
}