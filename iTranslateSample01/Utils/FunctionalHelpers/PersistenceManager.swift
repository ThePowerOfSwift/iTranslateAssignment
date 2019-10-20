//
//  PersistenceManager.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/20/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager {
    
    static let sharedInstance = PersistenceManager()
    
    private init() { }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Records")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - Create a Context
    
    lazy var context = persistentContainer.viewContext
}

//MARK: - Save Context

extension PersistenceManager {
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: - Get Contexts

extension PersistenceManager {
    
    func fetchContexts<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch (let err) {
            print(err.localizedDescription)
            return [T]()
        }
    }
}

//MARK: - Get Context Count

extension PersistenceManager {
    
    func fetchContextCount<T: NSManagedObject>(_ objectType: T.Type) -> Int {
        
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects?.count ?? 0
        } catch (let err) {
            print(err.localizedDescription)
            return 0
        }
    }
}

//MARK: - Delete Context With ID

extension PersistenceManager {
    
    func deleteContext<T: NSManagedObject>(_ objectType: T.Type, objectId: String) -> Bool {
        
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "recordId == %@", objectId)
        
        do {
            let records = try context.fetch(fetchRequest) as? [T]
            records?.forEach({ (record) in
                context.delete(record)
            })
            try context.save()
            return true
        } catch (let err) {
            print(err.localizedDescription)
            return false
        }
    }
}
