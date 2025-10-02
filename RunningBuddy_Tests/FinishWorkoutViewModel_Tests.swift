//
//  FinishWorkoutViewModel_Tests.swift
//  RunningBuddy_Tests
//
//  Created by Alexander Kozharin on 02.10.25.
//

import XCTest
@testable import RunningBuddy
import CoreLocation
final class FinishWorkoutViewModel_Tests: XCTestCase {
    
   func test_FinishWorkoutViewModel_stringValues_shouldBeEmpty() {
        let vm = FinishWorkoutViewModel()
       
       if vm.paceString.isEmpty && vm.dateString.isEmpty && vm.distanceString.isEmpty && vm.timeString.isEmpty {
           XCTAssert(true , "All string values should be empty")
       } else {
           XCTAssert(false , "Some string values are not empty")
       }
    }
    
    func test_FinishWorkoutViewModel_result_shouldBeNil(){
        let vm = FinishWorkoutViewModel()
        XCTAssertNil(vm.result)
    }
    
    
    func test_FinishWorkoutViewModel_saveWorkout_shoulSaveWorkout(){
        let vm = FinishWorkoutViewModel()
        vm.result = .init(pace: 10, distance: 10, duration: 10, path: [CLLocation.init(latitude: 10, longitude: 10)], calories: 10, avgHeartRate: 10, maxHeartRate: 10)
        var countBeforeSaving = 0
        var countAfterSaving = 0
        do {
            countBeforeSaving = try vm.workoutProvider.fetchAllWorkouts().count
        } catch {
            XCTAssert(false, "Failed to fetch workouts before saving")
        }
        vm.saveWorkout()
        
        do {
            countAfterSaving = try vm.workoutProvider.fetchAllWorkouts().count
            XCTAssertLessThan(countBeforeSaving, countAfterSaving)
        } catch {
            XCTAssert(false, "Failed to fetch workouts after saving")
        }
    }
    
    
    
    

}
