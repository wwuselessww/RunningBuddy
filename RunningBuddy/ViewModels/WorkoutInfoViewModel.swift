//
//  WorkoutInfoViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 12.05.25.
//

import SwiftUI
import HealthKit
import CoreLocation
import MapKit

class WorkoutInfoViewModel: ObservableObject {
    @Published var dateSting: String = ""
    @Published var workoutModel: HKWorkoutModel?
    @Published var timeString: String = ""
    @Published var distanceString: String = ""
    @Published var activeEnergyString: String = ""
    @Published var paceString: String = ""
    @Published var maxHearthRateString: String = ""
    @Published var avgHearthRateString: String = ""
    @Published var locationsArray: [CLLocation] = []
    @Published var splitArray: [Split] = []
    @Published var foodBurned: String = ""
    @Published var isLoading: Bool = true
    
    private var healthKitManager = HealthKitManager.shared
    
    func getDateInString(date: Date) {
        let formatter = DateFormatter()
        formatter.calendar = .current
        formatter.dateFormat = "EEEE, MMM d yyyy"
        dateSting = formatter.string(from: date)
    }
    
    @MainActor
    func getWorkoutData() async {
        guard let model = workoutModel else {return}
        if let workout = model.workout {
            timeString = model.workout?.duration.description ?? "NO TIME SHIT"
//            distanceString = String(format: "%0.2f", model.distance)
            avgHearthRateString = String(model.avgPulse ?? 0)
            
            let calendar = Calendar.current
            let componentsNow = calendar.dateComponents([.hour, .minute, .second], from: workout.startDate, to: workout.endDate)
            if let hour = componentsNow.hour, let minute = componentsNow.minute, let seconds = componentsNow.second {
                let resultTime = "\(hour):\(minute):\(seconds)"
                timeString = resultTime.toSportFormat()
            }
            let maxHearthRate = await healthKitManager.getBPMFor(workout: workout, type: .max, options: .discreteMax) ?? 0
            maxHearthRateString = String(maxHearthRate)
            //MARK: sus calculations
            let pace = await healthKitManager.getPaceFor(workout: workout) ?? 0
            paceString = String(format: "%0.2f", pace)
            //MARK: end of sus calculations
            let activeEnergy = await healthKitManager.getNumericFromHealthKit(startDate: workout.startDate, endDate: workout.endDate, sample: HKQuantityType(.activeEnergyBurned), resultType: HKUnit.largeCalorie())
            activeEnergyString = String(format: "%0.0f", activeEnergy?.rounded() ?? 0)
        } else {
            timeString = Double(model.duration ?? 0).timeString()
            paceString = String(format: "%0.2f", model.pace ?? 0)
        }
        distanceString = String(format: "%0.2f", model.distance)
    }
    
    @MainActor
    func getWorkoutPath() async {
        if let hWorkout = workoutModel?.workout {
            locationsArray = await healthKitManager.getRouteFor(workout: hWorkout) ?? []
            withAnimation(Animation.easeInOut) {
                isLoading = false
            }
        } else if let path = workoutModel?.path {
            for i in path {
                let tempLocation = CLLocation(latitude: i.latitude, longitude: i.longitude)
                locationsArray.append(tempLocation)
            }
            withAnimation(Animation.easeInOut) {
                isLoading = false
            }
        }
        
    }
    @MainActor
    func getZones() async {
        guard let workout = workoutModel?.workout else {return}
        splitArray = await healthKitManager.getHeartZonesFor(workout)
    }
    
    func calculateBurnedCaloriesInFood(caloriee: Int) -> String {
        let foodCalories: [Int: String] = [563:"🍔", 112:"🥤", 230: "🍕"]
        let sortedFoods = foodCalories.sorted(by: { $0.key > $1.key })
        var remainingCalories = caloriee
        var result = ""

        for (calories, emoji) in sortedFoods {
            let count = remainingCalories / calories
            if count > 0 {
                result += String(repeating: emoji, count: count)
                remainingCalories %= calories
            }
        }
        return result
    }
    
}
