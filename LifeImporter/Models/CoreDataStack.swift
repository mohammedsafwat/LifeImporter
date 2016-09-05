//
//  CoreDataStack.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/1/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import CoreData

struct CoreDataStack {
    private let managedObjectModel : NSManagedObjectModel
    private let persistentStoreCoordinator : NSPersistentStoreCoordinator
    private let mainContext : NSManagedObjectContext
    private let backgroundContext : NSManagedObjectContext
    private let modelUrl : NSURL
    private let dbUrl : NSURL
    
    // MARK: - Initializers
    init?(modelName : String) {
        // Assume that the model is in the main bundle
        guard let modelUrl = NSBundle.mainBundle().URLForResource(modelName, withExtension: "momd") else {
            print("Unable to find \(modelName) in the main bundle.")
            return nil
        }
        
        self.modelUrl = modelUrl
        
        // Create a model from the modelUrl
        guard let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelUrl) else {
            print("Unable to create a model from \(modelUrl)")
            return nil
        }
        
        self.managedObjectModel = managedObjectModel
        
        // Create the store coordinator
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        // Create the main context (will be used in main queue)
        mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        backgroundContext.parentContext = mainContext
        
        // Add a SQLite store located in the documents folder
        let fileManager = NSFileManager.defaultManager()
        
        guard let docUrl = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first else {
            print("Unable to get the url of the documents directory.")
            return nil
        }
        
        dbUrl = docUrl.URLByAppendingPathComponent("model.sqlite")
        
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: dbUrl, options: nil)
        } catch {
            print("Unable to add persistent store coordinator with url \(dbUrl)")
        }
    }
}

// MARK: - Removing data


// MARK: - Batch processing in the background
extension CoreDataStack {
    typealias Batch = (workerContext : NSManagedObjectContext) -> Void
    
    func performBackgroundBatchOperation(batch : Batch) {
        backgroundContext.performBlock {
            batch(workerContext: self.backgroundContext)
            
            do {
                try self.backgroundContext.save()
            } catch {
                fatalError("An error happened while trying to save the backgroundContext: \(error)")
            }
        }
    }
}
