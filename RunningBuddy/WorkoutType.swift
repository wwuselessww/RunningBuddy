//
//  WorkoutType.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.05.25.
//

import SwiftUI
//enum WorkoutType: String {
//    case outdoorRun = "Outdoor Run"
//    case outdoorWalk = "Outdoor Walk"
//}

enum WorkoutType: Identifiable, CaseIterable, Hashable {
    case outdoorRun
    case outdoorWalk
    
    var id: WorkoutType { self }
    
    var displayName: LocalizedStringKey {
        switch self {
        case .outdoorRun: return LocalizedStringKey("Outdoor Run")
        case .outdoorWalk: return LocalizedStringKey("Outdoor Walk")
        }
    }
}


