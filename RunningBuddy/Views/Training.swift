//
//  Training.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI

struct Training: View {
    var workout: Workout
    var body: some View {
        Text("\(workout)")
    }
}

#Preview {
    Training(workout: .init(difficulty: .init(level: "Easy", image: "🥰", color: .blue),
                            start: Activity(time: 5, type: .walking, repeats: 0),
                            core: [
                                Activity(time: 1, type: .running),
                                Activity(time: 2, type: .walking),
                                Activity(time: 6, type: .running),
                                Activity(time: 2, type: .walking),
                            ], coreRepeats: 1,
                            end: Activity(time: 5, type: .walking))
    )
}

