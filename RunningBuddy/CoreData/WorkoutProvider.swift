//
//  WorkoutProvider.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.07.25.
//

import SwiftUI
import CoreData

protocol WorkoutProviding {
    func fetchAllWorkouts() throws -> [Workout]
}

final class WorkoutProvider: WorkoutProviding {
    static let shared = WorkoutProvider()
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
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
    
    
    func fetchAllWorkouts() throws -> [Workout] {
        let request = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            return try viewContext.fetch(request)
        } catch {
            print("error fetching workouts: \(error)")
            return []
        }
    }
    
    func fetchWorkouts(from: Date, to: Date) throws -> [Workout] {
        let request = NSFetchRequest<Workout>(entityName: "Workout")
        request.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate <= %@", from as CVarArg, to as CVarArg)
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("cant fetch in range because \(error)")
            return []
        }
    }
    
    func deleteWorkoutWith(_ id: UUID) {
        let request = NSFetchRequest<Workout>(entityName: "Workout")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            guard let workoutToDelete = try viewContext.fetch(request).first else {
                print("no workout to delete***")
                return
            }
            print(workoutToDelete)
            viewContext.delete(workoutToDelete)
            save()
        } catch {
            print(error)
            print("cant fetch***")
        }
    }
    
    func createWorkout(workout result: WorkoutResultsModel?, date: Date = Date())  {
        guard let result = result else {
        print("no data" , result)
            return
        }
        let pace = result.pace
        let safePace = (pace.isNaN || pace.isInfinite) ? 0 : pace
        
        let tempWorkout = Workout(context: WorkoutProvider.shared.viewContext)
        tempWorkout.avgBPM = Int16(result.avgHeartRate ?? 0)
        tempWorkout.distance = result.distance
        tempWorkout.duration = Int64(result.duration)
        tempWorkout.maxBPM = Int16(result.maxHeartRate ?? 0)
        tempWorkout.pace = safePace
        let longitudes = result.path.map { $0.coordinate.longitude }
        let latitudes = result.path.map { $0.coordinate.latitude }
        tempWorkout.latitudes = latitudes as [Double]
        tempWorkout.longitudes = longitudes as [Double]
        tempWorkout.creationDate = date
        
        save()
        print("saved")
        print("workout to save \(tempWorkout)")
    }
    
    func save() {
        do {
            try viewContext.save()
            print("saved here")
        } catch {
            print(error)
        }
    }
    
}

extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
