//
//  MainPageViewModel_Tests.swift
//  RunningBuddy_Tests
//
//  Created by Alexander Kozharin on 02.10.25.
//

import XCTest

@testable import RunningBuddy
internal import CoreData

final class MainPageViewModel_Tests: XCTestCase {

    @MainActor func test_MainPageViewModel_totalMonthDistance_shouldBeZero() {
        let totalMonthDistance: Double = 0
        let vm = MainPageViewModel()
        let result = vm.totalMonthDistance
        XCTAssertTrue(result == totalMonthDistance)
    }
    
    
    
    
   @MainActor func test_MainPageViewModel_currentActivityIndex_shouldBeNotZero() {
        let currentActivityIndex = 0
       
       let vm = MainPageViewModel()
       let result = vm.currentActivityIndex
       XCTAssertTrue(result == currentActivityIndex)
    }
    
    @MainActor func test_MainPageViewModel_workModelArray_shouldBeEmpty() {
        let vm = MainPageViewModel()
        let result = vm.workModelArray
        XCTAssertTrue(result.isEmpty)
    }
    
    @MainActor func test_MainPageViewModel_didTapOnWorkout_shouldBeFalse() {
        let vm = MainPageViewModel()
        
        let result = vm.didTapOnWorkout
        XCTAssertTrue(result == false)
    }
    
    @MainActor func test_MainPageViewModel_currentIndexToDelete_shouldBeZero() {
        let currentIndexToDelete: Int = 0
        
        let vm = MainPageViewModel()
        let result = vm.currentIndexToDelete
        XCTAssertTrue(result == currentIndexToDelete)
    }
    
    @MainActor func test_MainPageViewModel_phoneRecordedWorkouts_shouldBeEmpty() {
        let vm = MainPageViewModel()
        let result = vm.phoneRecordedWorkouts
        XCTAssertTrue(result.isEmpty)
    }
    
    @MainActor func test_MainPageViewModel_workModelArray_shouldCreaateArray() async {
        let mockWorkout = Workout(context: WorkoutProvider.shared.viewContext)
        mockWorkout.creationDate = Date.now
        mockWorkout.distance = 10.0
        mockWorkout.duration = Int64(10.0)
        mockWorkout.pace = 10.0
        mockWorkout.avgBPM = Int16(10.0)
        mockWorkout.maxBPM = 10
        WorkoutProvider.shared.save()
        let vm = MainPageViewModel()
        vm.phoneRecordedWorkouts.append(mockWorkout)
        await vm.createWorkoutsArray()
        let result = vm.workModelArray
        XCTAssertTrue(!result.isEmpty)
    }
    
    @MainActor func test_MainPageViewModel_workModelArray_shoulDelete() {
        let vm = MainPageViewModel()
        vm.phoneRecordedWorkouts.append(Workout(context: WorkoutProvider.shared.viewContext))
        vm.workModelArray.append(HKWorkoutModel(id: UUID(), workout: .none, date: Date.now, distance: 10, avgPulse: 10, type: .outdoorRun, path: [], duration: 10, pace: 10, recordedByPhone: true))
        let counterBefore = vm.phoneRecordedWorkouts.count
        
        vm.delete(at: 0)
        
        let counterAfter = vm.phoneRecordedWorkouts.count
        print("phone \(vm.phoneRecordedWorkouts.count), model \(vm.workModelArray.count)")
        XCTAssertTrue(counterBefore > counterAfter)
    }
    
    
    
    
    
}
