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
        var formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
        
    }
}
