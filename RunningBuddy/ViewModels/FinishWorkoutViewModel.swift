//
//  FinishWorkoutViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.06.25.
//

import SwiftUI

class FinishWorkoutViewModel: ObservableObject {
    @Published var result: WorkoutResultsModel?
    @Published var paceString = ""
    @Published var timeString = ""
    @Published var distanceString = ""
    
    func formatResultData() {
        guard let result = result else { return }
        
        paceString = String(format: "%0.1f", result.pace)
        timeString = Double(result.duration).timeString()
        distanceString = String(format: "%0.1f", result.distance)
        print("paceString: \(paceString)")
        print("timeString: \(timeString)")
        print("timeString_result: \(result.duration)")
        print("distanceString: \(distanceString)")
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let newSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, newSeconds)
    }
}
