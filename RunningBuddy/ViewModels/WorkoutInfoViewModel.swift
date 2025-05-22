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
    @Published var workoutModel: WorkoutModel?
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
        let workout = model.workout
        timeString = model.workout.duration.description
        distanceString = String(format: "%0.2f", model.distance)
        avgHearthRateString = String(model.avgPulse)
        
        let calendar = Calendar.current
        let componentsNow = calendar.dateComponents([.hour, .minute, .second], from: workout.startDate, to: workout.endDate)
        if let hour = componentsNow.hour, let minute = componentsNow.minute, let seconds = componentsNow.second {
            print( "\(hour):\(minute):\(seconds)")
            let resultTime = "\(hour):\(minute):\(seconds)"
            timeString = resultTime.toSportFormat()
        } else {
            print("00:00:00")
        }
        let maxHearthRate = await healthKitManager.getMaxPulseFor(workout: workout) ?? 0
        print("maxHearthRate \(maxHearthRate)")
        maxHearthRateString = String(maxHearthRate)
        //MARK: sus calculations
        let pace = await healthKitManager.getPace(workout: workout) ?? 0
        paceString = String(format: "%0.2f", pace)
        //MARK: end of sus calculations
        
        let activeEnergy = await healthKitManager.getNumericFromHealthKit(startDate: workout.startDate, endDate: workout.endDate, sample: HKQuantityType(.activeEnergyBurned), resultType: HKUnit.largeCalorie())
        activeEnergyString = String(format: "%0.0f", activeEnergy?.rounded() ?? 0)
    }
    
    @MainActor
    func getWorkoutPath() async {
        guard let workout = workoutModel?.workout else {return}
        locationsArray = await healthKitManager.getRouteFor(workout: workout) ?? []
        withAnimation(Animation.easeInOut) {
            isLoading = false
        }
    }
    @MainActor
    func getZones() async {
        print("zones1")
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
            print(count)
            if count > 0 {
                result += String(repeating: emoji, count: count)
                remainingCalories %= calories
                print(remainingCalories %= calories)
                
            }
        }

        print("result", result)
        return result
    }
    
}
