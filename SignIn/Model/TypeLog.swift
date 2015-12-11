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
    let org = OrganizationLog().currentOrganization().organization
    
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
    
    func addType(title: String, id: Int, group: String, active: Int) {
        if isDupicateType(title) == false {
            let entity = NSEntityDescription.entityForName("Type", inManagedObjectContext: managedObjectContext)
            
            let type = Type(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            type.title = title
            type.active = active
            type.id = id
            type.group = group
            type.organization = OrganizationLog().currentOrganization().organization!
            //set default behaviour for organization
            
            saveType()
        }
    }
    
    func getType(id: Int) -> Type {
        let fetchRequest = NSFetchRequest(entityName: "Type")
        let NSID : NSNumber = id
        let predicate = NSPredicate(format: "id == %@", NSID)
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
    
    func getAllTypes() -> [Type] {
        var types = [Type]()
        for type in (org?.type)! {
            types.append(type as! Type)
        }
        return types
    }

    func getAllTypesForGroup(group: String) -> [Type] {
        var types = [Type]()
        for type in getAllTypes() {
            if type.group == group {
                types.append(type)
            }
        }
        return types
    }
    func getAllActiveTypesForGroup(group: String) -> [Type] {
        let types = getAllTypesForGroup(group)
        var activeTypes = [Type]()
        for type in types {
            if type.active == 1 {
                activeTypes.append(type)
            }
        }
        return activeTypes
    }
    
    func getActiveStatusOfTypesInOrderOfIDForGroup(group: String) -> [Bool] {
        var switchStatus = [Bool]()
        let types = getAllTypesForGroup(group)
        let sortedTypes = types.sort {Int($0.id!) < Int($1.id!)}
        for type in sortedTypes {
            if type.active == 0 {
                switchStatus.append(false)
            } else {
                switchStatus.append(true)
            }
        }
        return switchStatus
    }
}