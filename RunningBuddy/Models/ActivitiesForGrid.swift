//
//  ActivitiesForGrid.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 12.08.25.
//

import Foundation

struct ActivityForGrid: Identifiable {
    let id = UUID()
    let isRecorded: Bool
    let number: Int
}
