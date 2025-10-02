//
//  FinishWorkoutViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.06.25.
//

import SwiftUI
import CoreData
import CoreLocation

@Observable class FinishWorkoutViewModel {
    var result: WorkoutResultsModel?
    var paceString = ""
    var timeString = ""
    var distanceString = ""
    var dateString: String = ""
    var path: [CLLocationCoordinate2D] = []
    private var safePace: Double {
        guard let pace = result?.pace, !pace.isInfinite else { return 0 }
        return pace
    }
    var workoutProvider = WorkoutProvider.shared
    
    
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
    
    func saveWorkout()  {
        guard let result = result else {
        print("no data" , result)
            return
        }
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
        WorkoutProvider.shared.save()
        print("saved")
        print("workout to save \(tempWorkout)")
    }
}
