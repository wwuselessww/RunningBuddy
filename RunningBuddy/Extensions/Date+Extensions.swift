//
//  Date+Extensions.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.05.25.
//

import Foundation

extension Date {
    func formateToString() -> String {
        let date = self
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
        
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: startOfDay)!
        }
}
