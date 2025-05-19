//
//  WorkoutInfoViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 12.05.25.
//

import SwiftUI
import HealthKit

class WorkoutInfoViewModel: ObservableObject {
    @Published var dateSting: String = ""
    @Published var workoutModel: WorkoutModel?
    @Published var timeString: String = ""
    @Published var distanceString: String = ""
    @Published var activeEnergyString: String = ""
    @Published var paceString: String = ""
    @Published var maxHearthRateString: String = ""
    @Published var avgHearthRateString: String = ""
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
}
