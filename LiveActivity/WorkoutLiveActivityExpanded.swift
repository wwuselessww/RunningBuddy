//
//  WorkoutLiveActivityExpanded.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.08.25.
//

import SwiftUI
import WidgetKit
import ActivityKit


struct WorkoutLiveActivityExpanded: View {
    var stages: [Stage]
    
    var state: WorkoutAttributes.ContentState
    
    init(with state: WorkoutAttributes.ContentState) {
        self.stages = [
            .init(completed: true, current: false),
            .init(completed: true, current: false),
            .init(completed: true, current: false),
            .init(completed: true, current: false),
            .init(completed: true, current: true),
            .init(completed: false, current: false),
            .init(completed: false, current: false),
            .init(completed: false, current: false),
            .init(completed: false, current: false),
            .init(completed: false, current: false),
        ]
        self.state = state
    }
    
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image(systemName: "flag")
                        .foregroundStyle(.gray)
                    Capsule()
                        .frame(height: 10)
                        .foregroundStyle(.green)
                }
                ForEach(stages) { stage in
                    VStack {
                        Image(systemName: "figure.run")
                            .foregroundStyle(stage.current ? .white: .clear)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 10)
                            .foregroundStyle(stage.completed ? .green : .gray)
                    }
                }
                
                VStack {
                    Image(systemName: "flag.pattern.checkered")
                        .foregroundStyle(.gray)
                    Capsule()
                        .frame(height: 10)
                        .foregroundStyle(.gray)
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Running")
                        .font(.headline)
                    Text("Next will be walking")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Text("0:00")
                    .font(.largeTitle)
            }
            
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    let initialContentState = WorkoutAttributes.ContentState(activityName: ActivityType.running.rawValue, nextActivity: ActivityType.walking.rawValue, remainingTime: 0, speed: 10, pace: 0, stages: [])
    WorkoutLiveActivityExpanded(with: initialContentState)
}
