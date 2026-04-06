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
    private var heathStoreManager: HealthKitManager = .shared
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
    
    func saveWorkout() async {
        guard let result = result else {
        print("no data" , result)
            return
        }
        let calendar = Calendar.current
        do {
            let locations: [CLLocation] = path.map { location in
                    .init(latitude: location.latitude, longitude: location.longitude)
                
            }
            guard let paceNumber = Double(paceString) else {
                print("NO PACE WTF ")
                return
            }
            
            
            guard let start = calendar.date(byAdding: .second, value: result.duration * -1, to: Date.now) else {
                print("NO DATE WTF")
                return
            }
            
            let calories = calculateCalories(weightKg: 90, durationSeconds: Double(result.duration), paceMinPerKm: paceNumber)
            try await heathStoreManager.saveHKWorkout(start: start, end: Date.now, path: locations, calories: calories, distance: result.distance, type: result.type ?? .running)
        } catch {
            print("error in proccess of saving")
            print(error)
        }
    }
    
    private func metValue(paceMinPerKm: Double) -> Double {
        switch paceMinPerKm {
        case ..<4.0:  return 18.0  // sprinting > 15 km/h
        case 4.0..<4.5: return 16.0  // ~13-15 km/h
        case 4.5..<5.0: return 14.0  // ~12-13 km/h
        case 5.0..<5.5: return 11.5  // ~11-12 km/h
        case 5.5..<6.0: return 10.0  // ~10-11 km/h
        case 6.0..<6.5: return 9.0   // ~9-10 km/h
        case 6.5..<7.0: return 8.0   // ~8.5-9 km/h
        case 7.0..<8.0: return 7.0   // ~7.5-8.5 km/h
        case 8.0..<10.0: return 6.0  // ~6-7.5 km/h
        case 10.0...: return 3.5     // walking
        default: return 8.0
        }
    }
    
    private func calculateCalories(weightKg: Double, durationSeconds: Double, paceMinPerKm: Double) -> Double {
        let met = metValue(paceMinPerKm: paceMinPerKm)
        let durationHours = durationSeconds / 3600
        return met * weightKg * durationHours
    }
}
