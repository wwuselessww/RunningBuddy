//
//  WorkoutLiveActivityExpanded.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.08.25.
//

import SwiftUI



struct WorkoutLiveActivityExpanded: View {
    var stages: [Stage] = [
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
                ForEach(stages,) { stage in
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
    WorkoutLiveActivityExpanded()
}
