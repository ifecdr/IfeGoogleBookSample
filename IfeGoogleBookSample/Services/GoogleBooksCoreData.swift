//
//  GoogleBooksCoreData.swift
//  IfeGoogleBookSample
//
//  Created by MAC Consultant on 3/10/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
    
    // MARK: - Core Data stack

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IfeGoogleBookSample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    // read operation to return one result of the entity
    func getBook(_ name: String) -> Favorite? {
        
        // performing a (NS)FetchRequest from the context
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        
        // (optional: ) use NSPredicates to better-define our search
        let predicate = NSPredicate.init(format: "name == %@", name)
        fetchRequest.predicate = predicate
        do {
            let books = try context.fetch(fetchRequest)
            print("There are \(books.count) many books in Core Data")
            return books.first
        }
        catch {
            print("Error in loading from file")
        }
        return nil
    }
    
    // read operation to fetch all the books in the file
    func getAllBooks() -> [Favorite] {
        // performing a (NS)FetchRequest from the context
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        
        // (optional: ) use NSPredicates to better-define our search
        do {
            let books = try context.fetch(fetchRequest)
            print("There are \(books.count) many books in Core Data")
            return books
        }
        catch {
            print("Error in loading from file")
        }
        return []
    }
    
    // performing delete operation
    func deleteBook(_ book: Favorite) {
        // delete from context
        context.delete(book)
        // persist changes in context to persistentStore
        saveContext()
    }
    
    // performing write operation
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // performing read operation with a parameter string
    func findAll(_ name: String) -> [Favorite] {
        // performing a (NS)FetchRequest from the context
        let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
        
        // (optional: ) use NSPredicates to better-define our search
        // NSPredicates & Queries are very similar
        let predicate = NSPredicate.init(format: "name == %@", name)
        fetchRequest.predicate = predicate
        do {
            let books = try context.fetch(fetchRequest)
            print("There are \(books.count) many \(name)'s in Core Data")
            return books
        }
        catch {
            print("Error in loading from file")
        }
        return []
    }

}



