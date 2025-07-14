//
//  FinishWorkoutViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.06.25.
//

import SwiftUI
import CoreData
import CoreLocation

class FinishWorkoutViewModel: ObservableObject {
    @Published var result: WorkoutResultsModel?
    @Published var workout: Workout
    @Published var paceString = ""
    @Published var timeString = ""
    @Published var distanceString = ""
    @Published var dateString: String = ""
    @Published var path: [CLLocationCoordinate2D] = []
    private var safePace: Double {
        guard let pace = result?.pace, !pace.isInfinite else { return 0 }
        return pace
    }
    private let context: NSManagedObjectContext
    var resultWorkout: WorkoutResultsModel?
    var workoutProvider = WorkoutProvider.shared
    
    init(provider: WorkoutProvider, workout: Workout? = nil) {
        self.context = provider.newContext
        self.workout = Workout(context: self.context)
    }
    
    func formatResultData() {
        guard let result = result else { return }
        paceString = String(format: "%0.1f", safePace)
        timeString = Double(result.duration).timeString()
        distanceString = String(format: "%0.1f", result.distance)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        dateString = dateFormatter.string(from: Date.now)
        createPath()
    }
    
   private func createPath() {
        guard let result = result else { return }
        path = result.path.map{$0.coordinate}
    }
    
    func saveWorkout() throws  {
        guard let result = result else { return }
        workout.avgBPM = Int16(result.avgHeartRate ?? 0)
        workout.distance = result.distance
        workout.duration = Int64(result.duration)
        workout.maxBPM = Int16(result.maxHeartRate ?? 0)
        workout.pace = safePace
        let longitudes = result.path.map { $0.coordinate.longitude }
        let latitudes = result.path.map { $0.coordinate.latitude }
        workout.latitudes = latitudes as [Double]
        workout.longitudes = longitudes as [Double]
        if context.hasChanges {
            try context.save()
        }
    }
}
