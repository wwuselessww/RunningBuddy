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
                let fetched = await fetchWorkoutsForSelected(selectedChip)
                            await MainActor.run {
                                workouts = fetched
                            }
                await changeCalloutText()
                await getStepsForDuration(selectedChip: selectedChip)
                await setStepsLabel()
                await getWorkoutDistanceForDuration(selectedChip: selectedChip)
            }
        }
    }
    @Published var pickerOptions: [ProgressPickerOption] = [.day, .week, .month, .year]
    @Published var workouts: [Workout] = []
    @Published var callout: String = ""
    @Published var steps: [ChartModel] = []
    @Published var distance: [ChartModel] = []
    @Published var stepsCount: Int = 0
    @Published var distanceLabel: Int = 0
    @Published var activites: [ActivityForGrid] = []
    @Published var monthlyWorkouts: [Workout] = []
    var activitiesMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: Date())
    }
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    let healthKitManager = HealthKitManager.shared

    func fetchWorkoutsForSelected(_ option: ProgressPickerOption) async -> [Workout] {
        let now = Date.now
        let calendar: Calendar = Calendar.current
        switch option {
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
            return fetchedWorkouts
//            await populateActivites()
//            await MainActor.run {
//                workouts = fetchedWorkouts
//            }
        } catch {
            print("error fetching workouts: \(error)")
            return []
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
    
   private func getArrayOfDatesInCurrentMonth() -> [Date]?  {
        let now = Date.now
        let calendar = Calendar.current
        guard let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start else {
            print("😰")
            return nil
        }
        guard let daysInMonth = calendar.range(of: .day, in: .month, for: now) else {
            print("😰1")
            return nil
        }
        var result: [Date] = []
        for day in daysInMonth {
            guard let date = calendar.date(byAdding: DateComponents(day: day), to: startOfMonth) else {
                print("😰2")
                return nil
            }
            result.append(date)
        }
        return result
    }
    
    func populateActivites() async {
        print("kek")
        await MainActor.run {
            activites.removeAll()
        }
        guard let datesInCurrentMonth =  getArrayOfDatesInCurrentMonth() else {
            print("No dates found")
            return
        }
        let workoutsToFetch = await fetchWorkoutsForSelected(.month)
        let fetchedDates = workoutsToFetch.map { $0.creationDate }
        print("kqk1")
        for date in datesInCurrentMonth {
            for fetchedDate in fetchedDates {
                if (date.startOfDay...date.endOfDay).contains(fetchedDate) {
                    print("YEA")
                    await MainActor.run {
                        activites.append(.init(isRecorded: true, number: 1))
                    }
                    break
                } else {
                    print("no(")
                    await MainActor.run {
                        activites.append(.init(isRecorded: false, number: 1))
                    }
                    break
                }
            }
        }
    }
    
    
    
    func getStepsForDuration(selectedChip: ProgressPickerOption) async {
          let interval: DateComponents
          switch selectedChip {
          case .day:
              interval = DateComponents(hour: 1)
          case .week:
              interval = DateComponents(day: 1)
          case .month:
              interval = DateComponents(day: 1)
          case .year:
              interval = DateComponents(month: 1)
          }
          let data = await healthKitManager.getStepsForPeriod(
              startDate: startDate,
              endData: endDate,
              type: HKQuantityType(.stepCount),
              options: [.cumulativeSum],
              interval: interval,
              resultType: .count()
          )
          await MainActor.run {
              self.steps = data
          }
      }
    
    func getWorkoutDistanceForDuration(selectedChip: ProgressPickerOption) async {
        let distanceArray: [ChartModel] = workouts.map{ChartModel(date: $0.creationDate, number: Int($0.distance))}
        let distanceLabel = distanceArray.reduce(0, {$0 + $1.number})
        
        await MainActor.run {
            self.distance = distanceArray
            self.distanceLabel = distanceLabel
        }
        
        print("distanceArray \(distanceArray)")
    }
    
    func setStepsLabel() async {
        let totalSteps = steps.reduce(0, {$0 + $1.number})
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
//distanceArray [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0860846003425477, 9.412533233413049e-07, 0.0]
