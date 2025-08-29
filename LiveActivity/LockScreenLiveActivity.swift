//
//  LockScreenLiveActivity.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 18.08.25.
//

import SwiftUI
import WidgetKit

struct LockScreenLiveActivity: View {
    var state: WorkoutAttributes.ContentState
    
    init(with state: WorkoutAttributes.ContentState) {
        self.state = state
    }
    
    var body: some View {
        HStack {
            Image(systemName: state.activityName == ActivityType.running.rawValue ? "figure.running" : "figure.walking")
            
            VStack (alignment: .leading) {
                Text(state.activityName.capitalized)
                    .font(.headline)
                Text("next will be: \(state.nextActivity.capitalized)")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            Spacer()
            Text(Double(state.remainingTime).timeString())
                .contentTransition(.numericText())
                .font(.title)
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Speed: \(String(format: "%0.1f",state.remainingTime))km/h")
                    .font(.caption2)
                Text("Pace: \(String(format: "%0.1f",state.pace))")
                    .font(.caption2)
                Text("Stage: 1/5")
                    .font(.caption2)
            }
                    
                
                
            }
        .font(.title)
        .padding(.horizontal)
    }
}


