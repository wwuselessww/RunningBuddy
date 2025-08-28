//
//  LockScreenLiveActivity.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 18.08.25.
//

import SwiftUI

struct LockScreenLiveActivity: View {
    var body: some View {
        HStack {
            Image(systemName: "figure.run")
            
            VStack (alignment: .leading) {
                Text("Running")
                    .font(.headline)
                Text("next will be: Running")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            Spacer()
            Text("0:00")
                .contentTransition(.numericText())
                .font(.title)
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Speed: 10 km/h")
                    .font(.caption2)
                Text("Pace: 10:00")
                    .font(.caption2)
                Text("Stage: 1/5")
                    .font(.caption2)
            }
                    
                
                
            }
        .font(.title)
        .padding(.horizontal)
    }
}


