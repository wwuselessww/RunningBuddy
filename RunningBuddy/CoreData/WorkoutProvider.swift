//
//  WorkoutProvider.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.07.25.
//

import Foundation
import CoreData

final class WorkoutProvider {
    static let shared = WorkoutProvider()
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "WorkoutsDataModel")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("unable to load persistent stores: \(error)")
            }
            print("container loaded")
        }
    }
    
    func test() {
        print("kek")
    }
    
    
}
