//
//  WorkoutViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 23.05.25.
//

import SwiftUI

class WorkoutViewModel: ObservableObject {
    @Published var selectedDifficulty: WorkoutDifficulty = .init(level: "Easy", image: "🥰", color: .blue)
//    var difficultyArray: [String] = ["Easy","Medium","Hard","Free run"]
    var difficultyArray: [WorkoutDifficulty] = [
        .init(level: "Easy", image: "🥰", color: .blue),
        .init(level: "Medium", image: "🫡", color: .yellow),
        .init(level: "Hard", image: "😔", color: .red),
        .init(level: "Free run", image: "😌", color: .green),
    ]
}

struct WorkoutDifficulty: Hashable {
    let level: String
    let image: String
    let color: Color
}
