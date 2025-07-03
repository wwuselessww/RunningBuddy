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
//        let timeInterval = TimeInterval(self)
        let startingDate = start
        let calendar = Calendar.current
        
        let componentsNow = calendar.dateComponents([.hour, .minute, .second], from: startingDate, to: endingDate)
        if let hour = componentsNow.hour, let minute = componentsNow.minute, let seconds = componentsNow.second {
            return "\(hour):\(minute):\(seconds)"
        } else {
            return "00:00:00"
        }
    }
}
