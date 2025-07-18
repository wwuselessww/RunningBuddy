//
//  ProgressViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 14.07.25.
//


import SwiftUI
import HealthKit

final class ProgressViewModel: ObservableObject {
    @Published var selectedChip: ProgressPickerOption = .day {
        didSet {
            Task {
                await fetchWorkoutsForSelectedOption()
               await changeCalloutText()
                await getStepsForDuration()
            }
        }
    }
    @Published var pickerOptions: [ProgressPickerOption] = [.day, .week, .month, .year]
    @Published var workouts: [Workout] = []
    @Published var callout: String = ""
    @Published var steps: [Int] = []
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    let healthKitManager = HealthKitManager.shared
    
    func fetchWorkouts() async {
        do {
            let temp = try  WorkoutProvider.shared.fetchAllWorkouts()
            await MainActor.run {
                workouts = temp
            }
            print(workouts.count)
        } catch {
            print("error fetching workouts: \(error)")
        }
    }
    func fetchWorkoutsForSelectedOption() async {
        
        let now = Date.now
        let calendar: Calendar = Calendar.current
        switch selectedChip {
        case .day:
            startDate = calendar.startOfDay(for: now)
        case .week:
            startDate = calendar.startOfWeek(for: now) ?? now
        case .month:
            startDate = calendar.startOfMonth(for: now) ?? now
        case .year:
            startDate = calendar.startOfYear(for: now) ?? now
        }
        endDate = now
        do {
            let fetchedWorkouts = try  WorkoutProvider.shared.fetchWorkouts(from: startDate, to: endDate)
            print(fetchedWorkouts.count)
            await MainActor.run {
                workouts = fetchedWorkouts
            }
        } catch {
            print("error fetching workouts: \(error)")
        }
    }

    func changeCalloutText() async {
        let dateFormatter = DateFormatter()
        var textToshow: String = ""
        switch selectedChip {
        case .day:
            textToshow = "today"
        case .week:
            textToshow = "current week"
        case .month:
            dateFormatter.dateFormat = "MMMM"
            let currentMonth = dateFormatter.string(from: Date.now)
            textToshow = currentMonth
        case .year:
            dateFormatter.dateFormat = "yyyy"
            let currentYear = dateFormatter.string(from: Date.now)
            textToshow = currentYear
        }
        await MainActor.run {
            callout = textToshow
        }
    }
    
    func getStepsForDuration() async {
//       let count =  await healthKitManager.getNumericFromHealthKit(startDate: startDate, endDate: endDate, sample: HKQuantityType(.stepCount), resultType: .count())
        let inteval = DateComponents(day: 1)
        let countArray: [Double] = await healthKitManager.getNumericArray(startDate: startDate, endData: endDate, type: HKQuantityType(.stepCount), options: [.cumulativeSum], interval: inteval, resultType: .count())
        print("res \(countArray)")
    }
    
}


enum ProgressPickerOption: String {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
