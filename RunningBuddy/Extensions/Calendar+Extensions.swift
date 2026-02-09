//
//  Calendar+Extensions.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 14.07.25.
//

import Foundation

extension Calendar {
    func startOfWeek(for date: Date) -> Date? {
        guard let startOfWeek = self.dateInterval(of: .weekOfYear, for: date) else {
            return nil
        }
        guard let actualStartOfWeek = startOfWeek.start as Date? else {
            return nil
        }
        return actualStartOfWeek
    }
    
    //MARK: strange time 21:00 and  not 0:00
    func startOfMonth(for date: Date) -> Date? {
        let startOfMonth = self.dateInterval(of: .month, for: date)
        guard let actualStart = startOfMonth?.start else {
            return nil
        }
        return actualStart
    }
    
    func startOfYear(for date: Date) -> Date? {
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: date)
        guard let endOfLastYear = self.date(from: components) else {
            return nil
        }
        guard let startOfyear = self.date(byAdding: .day, value: 1, to: endOfLastYear) else {
            return nil
        }
        return startOfyear
    }
}
