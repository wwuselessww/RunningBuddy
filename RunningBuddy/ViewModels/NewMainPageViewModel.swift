//
//  NewMainPageViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 29.01.26.
//

import SwiftUI
import HealthKit
import CoreLocation

@Observable class NewMainPageViewModel {
    var days: [Days] = [.init(name: "mon", number: 0),.init(name: "tue", number: 0),.init(name: "wen", number: 0),.init(name: "thu", number: 0),.init(name: "fri", number: 0),.init(name: "sat", number: 0),.init(name: "sun", number: 0)]
    
    var activityValue = 0.1
    var waterLevel = 0.7
    var isPressed : Bool = false
    var chosenDay: Int = 0
    var waterTitle: Int = 10
    var activityTitle: Int = 15
    var authenticated: Bool = false
    var trigger: Bool = false
    
    var maxActivity: Int = 1000
    var currentActivityIndex: Int = 0
    var hkWorkouts: [HKWorkoutModel] = []
    var didTapOnWorkout: Bool = false
    var currentIndexToDelete: Int = 0
    
    var phoneRecordedWorkouts: [Workout] = []
    
    var healtKitManager = HealthKitManager.shared
    private  var store = HealthKitManager.shared.healthStore
    private let startOfTheDay = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    private let currentTime = Date()
    private let workoutProvider: WorkoutProvider
    private var startOfTheWeek: Date  {
        return calendar.startOfWeek(for: Date.now) ?? Date.now
    }
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "en_GB")
        calendar.timeZone = .current
        return calendar
    }
    
    var chosenDate: Date = Calendar.current.startOfDay(for: Date.now)
    
    init(workoutProvider: WorkoutProvider = WorkoutProvider.shared) {
        self.workoutProvider = workoutProvider
        setCurrentDay()
    }
    
    func setCurrentDay() {
        chosenDay = calendar.component(.day, from: Date.now)
    }
    
    func getWeekArray() {
//        let calendar = Calendar.current
        let startOfTheWeek = calendar.startOfWeek(for: Date.now)!
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: i, to: startOfTheWeek)!
            days[i].number = calendar.component(.day, from: date)
        }
    }
    
    @MainActor func setCurrentDate(_ date: Int) {
        print("changed date")
        chosenDate = calendar.date(byAdding: .day, value: date, to: startOfTheWeek) ?? Date.now
        print("chosen date\(calendar.component(.weekday, from: chosenDate)))")
        
        getWorkouts()
    }
    
    
    
    
    
    
    @MainActor
    func getWorkouts() {
        let stepCounter = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let workoutType = HKObjectType.workoutType()
        store.requestAuthorization(toShare: [], read: [stepCounter, workoutType]) { isSuccess, error in
            if isSuccess {
                self.getWeekArray()
                Task {
                    await self.getCalloriesFromHK()
                    await self.createWorkoutsArray()
                    await self.getHKWorkouts()
                }
                
            } else {
                print(error!)
            }
        }
    }
    
    @MainActor
    func createWorkoutsArray() async {
        hkWorkouts = []
        var tempArray: [HKWorkoutModel] = []
        for workout in phoneRecordedWorkouts {
            var path: [CLLocationCoordinate2D] = []
            if let latitudes = workout.latitudes, let longitudes = workout.longitudes {
                var tempPath: CLLocationCoordinate2D
                for cordIndex in 0..<latitudes.count {
                    tempPath = .init(latitude: latitudes[cordIndex], longitude: longitudes[cordIndex])
                    path.append(tempPath)
                }
            } else {
                print("no data coordinates")
            }
            let workoutModel: HKWorkoutModel = .init(
                workout: nil,
                date: workout.creationDate,
                distance: workout.distance,
                avgPulse: nil,
                type: .outdoorRun,
                path: path,
                duration: Int(workout.duration),
                pace: workout.pace,
                recordedByPhone: true
            )
            tempArray.append(workoutModel)
        }
        hkWorkouts += tempArray
        hkWorkouts.sort { $0.date > $1.date }
    }
    
    @MainActor
    private func getCalloriesFromHK() async {
        guard let res = await healtKitManager.getNumericFromHealthKit(startDate: startOfTheDay, endDate: currentTime, sample: HKQuantityType(.activeEnergyBurned), resultType: .largeCalorie()) else {
            return
        }
        currentActivityIndex = Int(res)
    }
    
    @MainActor
    func getHKWorkouts() async {
        print("")
        print("")
        print(startOfTheWeek)
        print(currentTime)
        print("")
        print("")
        let res = await healtKitManager.getWorkouts(from: chosenDate, to: currentTime)
        print("resarray size", res.count)
        var modelArray: [HKWorkoutModel] = []
        for i in res {
            let date = i.startDate
            guard  let distance = i.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)), let pulse = await healtKitManager.getBPMFor(workout: i, type: .avg, options: .discreteAverage) else {
                print("no data")
                break
            }
            
            let newWorkout = HKWorkoutModel(workout: i, date: date, distance: distance, avgPulse: pulse, type: .outdoorRun)
            modelArray.append(newWorkout)
            
        }
        hkWorkouts += modelArray
        print("workModelArray", hkWorkouts)
    }
    
    func getPhoneRecordedWorkouts() {
        do {
            let res = try workoutProvider.fetchWorkouts(from: chosenDate, to: currentTime)
            print("")
            print("res: \(res)")
            print("res.count: \(res.count)")
            print("")
            phoneRecordedWorkouts = res
            
        } catch {
            print(error)
            print("cant fetch workouts***")
        }
    }
    
    func delete(at index: Int) {
        if index >= phoneRecordedWorkouts.count {
            print("cant delete this")
            return
        }
        let workout = phoneRecordedWorkouts[index]
        phoneRecordedWorkouts.remove(at: index)
        withAnimation {
            hkWorkouts.remove(at: index)
        }
        WorkoutProvider.shared.deleteWorkoutWith(workout.id)
    }
    func debug(_ date: Date, calendar: Calendar) {
        print("debug".capitalized)
        print("weekday:", calendar.component(.weekday, from: date)) // 2 = Monday
        print("local:", date.formatted(date: .complete, time: .complete))
        print("UTC:", date)
    }
}
