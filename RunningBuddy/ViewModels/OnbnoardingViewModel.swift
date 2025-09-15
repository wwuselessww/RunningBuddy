//
//  OnbnoardingViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 01.09.25.
//

import SwiftUI

@Observable class OnbnoardingViewModel {
    var animationToggle: Bool = true
    var rotationAngle: Double = 0
    var locationGranted: Bool = false
    var healthKitGranted: Bool = false
    var healthKitTrigger: Bool = false
    var healKitManager = HealthKitManager.shared
    var isCompleted: Bool = false
    var errorText: String = ""
    
    func checkOnboardingCompletion(){
        if healthKitGranted && locationGranted && isCompleted {
            UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
            print("Granted")
        } else {
            withAnimation(.bouncy) {
                errorText = ""
                if !healthKitGranted {
                    errorText += "Access to Health data isnt granted \n"
                }
                
                if !locationGranted {
                    errorText += "Access to location isnt granted"
                }
            }
            UserDefaults.standard.set(false, forKey: "isOnboardingCompleted")
            print("not Granted")
        }
    }
    func test(){
        print("rest")
    }
    
}
