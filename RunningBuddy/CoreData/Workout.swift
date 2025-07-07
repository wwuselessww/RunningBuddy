//
//  Workout.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.07.25.
//

import Foundation
import CoreData

final class Workout: NSManagedObject, Identifiable {
    @NSManaged var avgBPM: Int16
    @NSManaged var maxBPM: Int16
    @NSManaged var distance: Double
    @NSManaged var duration: Int64
    @NSManaged var id: UUID
    @NSManaged var pace: Double
    @NSManaged var creationDate: Date
    
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
