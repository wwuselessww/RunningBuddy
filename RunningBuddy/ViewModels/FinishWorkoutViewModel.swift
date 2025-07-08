//
//  FinishWorkoutViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.06.25.
//

import SwiftUI
import CoreData

class FinishWorkoutViewModel: ObservableObject {
    @Published var result: WorkoutResultsModel?
    @Published var workout: Workout
    @Published var paceString = ""
    @Published var timeString = ""
    @Published var distanceString = ""
    @Published var dateString: String = ""
    private let context: NSManagedObjectContext
    var resultWorkout: WorkoutResultsModel?
    var workoutProvider = WorkoutProvider.shared
    
    init(provider: WorkoutProvider, workout: Workout? = nil) {
        self.context = provider.newContext
        self.workout = Workout(context: self.context)
    }
    
    func formatResultData() {
        guard let result = result else { return }
        paceString = String(format: "%0.1f", result.pace)
        timeString = Double(result.duration).timeString()
        distanceString = String(format: "%0.1f", result.distance)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        dateString = dateFormatter.string(from: Date.now)
    }
    
    func saveWorkout() throws  {
        //FIXME: handle saving
        guard let result = result else { return }
        workout.avgBPM = Int16(result.avgHeartRate ?? 0)
        workout.distance = result.distance
        workout.duration = Int64(result.duration)
        workout.maxBPM = Int16(result.maxHeartRate ?? 0)
        workout.pace = result.pace
        let longitudes = result.path.map { $0.coordinate.longitude }
        let latitudes = result.path.map { $0.coordinate.latitude }
        workout.latitudes = latitudes as [Double]
        workout.longitudes = longitudes as [Double]
        if context.hasChanges {
            try context.save()
        }
    }
}
