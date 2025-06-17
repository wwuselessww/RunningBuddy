//
//  Numeric+Extensions.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 16.06.25.
//

import Foundation
extension BinaryFloatingPoint {
    func timeString() -> String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
