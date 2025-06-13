//
//  TrainingViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI

class TrainingViewModel: ObservableObject {
    
    
    @Published var workout: Workout?
    @Published var isActive: Bool = true
    @Published var timerDisplay: String = "0:00"
    @Published var isPlayPausePressed: Bool = false
    @Published var now: Date = Date.now
    @Published var plusSecond: Date = Date.now
    
    var calendar = Calendar.current
    
   
    
    var image: Image = Image(systemName: "play.fill")
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func stopTimer() {
        timer.upstream.connect().cancel()
        image = Image(systemName: "play.fill")
        
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        image = Image(systemName: "pause.fill")
        
    }
    
    func getTimeDifference(from: Date, to: Date) {
        plusSecond = calendar.date(byAdding: .second, value: 1, to: plusSecond) ?? Date.now
        var interval = from.distance(to: plusSecond)
        print(interval.minuteSecond)
        timerDisplay = interval.minuteSecond
    }
    
}
