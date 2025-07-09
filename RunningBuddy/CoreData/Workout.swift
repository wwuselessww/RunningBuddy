//
//  Workout.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.07.25.
//

import Foundation
import CoreData
import CoreLocation

@objc(Workout)
final class Workout: NSManagedObject, Identifiable {
    @NSManaged var avgBPM: Int16
    @NSManaged var maxBPM: Int16
    @NSManaged var distance: Double
    @NSManaged var duration: Int64
    @NSManaged var id: UUID
    @NSManaged var pace: Double
    @NSManaged var creationDate: Date
    @NSManaged var latitudes: [Double]?
    @NSManaged var longitudes: [Double]?
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue(Date.now, forKey: "creationDate")
    }
}


extension Workout {
    private static var workoutsFetchRequest: NSFetchRequest<Workout> {
        NSFetchRequest(entityName: "Workout")
    }
    
    static func all() -> NSFetchRequest<Workout> {
        let request: NSFetchRequest<Workout> = Workout.workoutsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Workout.creationDate, ascending: true)
        ]
        return request
    }
    
    
}


extension Workout {
    @discardableResult
   static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Workout] {
        var workouts = [Workout]()
        
        for i in 0..<count {
            let workout = Workout(context: context)
            workout.avgBPM = Int16.random(in: 100...200)
            workout.maxBPM = Int16.random(in: 100...200)
            workout.distance = Double.random(in: 0...10)
            workout.duration = Int64.random(in: 0...1000)
            workout.pace = Double.random(in: 0...20)
            workout.creationDate = Date().addingTimeInterval(-TimeInterval(i))
            workouts.append(workout)
        }
        return workouts
    }
    
    static func preview(context: NSManagedObjectContext = WorkoutProvider.shared.viewContext) -> Workout {
        return makePreview(count: 1, in: context)[0]
    }
    
    static func empty(context: NSManagedObjectContext = WorkoutProvider.shared.viewContext) -> Workout {
        return Workout(context: context)
    }
}
