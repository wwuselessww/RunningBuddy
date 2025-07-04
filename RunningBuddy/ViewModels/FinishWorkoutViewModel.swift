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
    @Published var dateString: String = ""
    func formatResultData() {
        guard let result = result else { return }
        
        paceString = String(format: "%0.1f", result.pace)
        timeString = Double(result.duration).timeString()
        distanceString = String(format: "%0.1f", result.distance)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        dateString = dateFormatter.string(from: Date.now)
        print("paceString: \(paceString)")
        print("timeString: \(timeString)")
        print("timeString_result: \(result.duration)")
        print("distanceString: \(distanceString)")
    }
    
    func saveWorkout() {
        //FIXME: handle saving 
    }
}
