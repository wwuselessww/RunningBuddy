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
                await setStepsLabel()
            }
        }
    }
    @Published var pickerOptions: [ProgressPickerOption] = [.day, .week, .month, .year]
    @Published var workouts: [Workout] = []
    @Published var callout: String = ""
    @Published var steps: [Double] = []
    @Published var stepsCount: Int = 0
    
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
    @MainActor
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
            callout = textToshow
    }
    
    func getStepsForDuration() async {
        let interval = selectedChip == .day ? DateComponents(hour: 1) : DateComponents(day: 1)
        let result = await healthKitManager.getNumericArray(startDate: startDate, endData: endDate, type: HKQuantityType(.stepCount), options: [.cumulativeSum], interval: interval, resultType: .count())
        await MainActor.run {
            steps = result
        }
    }
    
    func setStepsLabel() async {
        let totalSteps = steps.reduce(0, +)
        print("totalSteps \(totalSteps)")
        await MainActor.run {
            withAnimation {
                stepsCount = Int(totalSteps)
            }
        }
    }
    
}


enum ProgressPickerOption: String {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
