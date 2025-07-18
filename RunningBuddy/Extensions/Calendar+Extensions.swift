//
//  Calendar+Extensions.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 14.07.25.
//

import Foundation

extension Calendar {
    func startOfWeek(for date: Date) -> Date? {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return nil
        }
        guard let actualStartOfWeek = startOfWeek.start as Date? else {
            return nil
        }
        return actualStartOfWeek
    }
    
    //MARK: strange time 21:00 and  not 0:00
    func startOfMonth(for date: Date) -> Date? {
        let calendar = Calendar.current
        print(calendar)
        let startOfMonth = calendar.dateInterval(of: .month, for: date)
        guard let endOfLastMonth = startOfMonth?.start else {
            return nil
        }
        guard let lastDay = calendar.date(byAdding: .day, value: 1, to: endOfLastMonth) else {
            return nil
        }
        return calendar.startOfDay(for: lastDay)
    }
    
    func startOfYear(for date: Date) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: date)
        guard let endOfLastYear = calendar.date(from: components) else {
            return nil
        }
        guard let startOfyear = calendar.date(byAdding: .day, value: 1, to: endOfLastYear) else {
            return nil
        }
        return startOfyear
    }
}
