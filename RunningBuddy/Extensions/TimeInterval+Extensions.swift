//
//  TimeInterval+Extensions.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 19.05.25.
//

import Foundation

extension TimeInterval {
    func stringFromTimeInterval (start: Date, end: Date) -> String {
        let endingDate = end
        let timeInterval = TimeInterval(self)
        let startingDate = start
        let calendar = Calendar.current
        
        var componentsNow = calendar.dateComponents([.hour, .minute, .second], from: startingDate, to: endingDate)
        if let hour = componentsNow.hour, let minute = componentsNow.minute, let seconds = componentsNow.second {
            return "\(hour):\(minute):\(seconds)"
        } else {
            return "00:00:00"
        }
    }
    
    
        var hourMinuteSecondMS: String {
            String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
        }
        var minuteSecond: String {
            String(format:"%d:%02d", minute, second)
        }
        var hour: Int {
            Int((self/3600).truncatingRemainder(dividingBy: 3600))
        }
        var minute: Int {
            Int((self/60).truncatingRemainder(dividingBy: 60))
        }
        var second: Int {
            Int(truncatingRemainder(dividingBy: 60))
        }
        var millisecond: Int {
            Int((self*1000).truncatingRemainder(dividingBy: 1000))
        }
}
