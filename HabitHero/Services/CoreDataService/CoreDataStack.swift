//
//  CoreDataStack.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HabitHero")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed to load: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func setupCoreData() {
        _ = persistentContainer
        print("Core Data initialized")
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
}
