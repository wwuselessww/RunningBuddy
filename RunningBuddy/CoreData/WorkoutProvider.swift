//
//  WorkoutProvider.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.07.25.
//

import SwiftUI
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
        
        ValueTransformer.setValueTransformer(DoubleArrayTransformer(), forName: NSValueTransformerName("DoubleArrayTransformer"))
        
        persistentContainer = NSPersistentContainer(name: "WorkoutsDataModel")
        if EnvironmentValues.isPreview {
            persistentContainer.persistentStoreDescriptions.first?.url = .init(filePath: "/dev/null")
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("unable to load persistent stores: \(error)")
            }
            print("container loaded")
        }
    }
    
}

extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
