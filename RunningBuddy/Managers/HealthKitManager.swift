//
//  HealthKitManager.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.05.25.
//

import SwiftUI
import HealthKit

class HealthKitManager {
    static var shared = HealthKitManager()
    var healthStore = HKHealthStore()
    
    let activityTypes: Set = [
        HKQuantityType.workoutType(),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.basalEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.heartRate),
    ]
    
    func ensuresHealthKitSetup()  {
        
        
        if HKHealthStore.isHealthDataAvailable() {
            print("health kit is available")
        } else {
            print("health kit is not available")
        }
    }
}

