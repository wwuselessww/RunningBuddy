//
//  Training.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI

struct Training: View {
    @StateObject var vm = TrainingViewModel()
    
    var workout: Workout
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<10, id: \.self) { part in
                    Circle()
                        .frame(width: 29)
                }
            }
            Spacer()
            Text("Running")
                .font(.system(size: 40, weight: .semibold))
            Text("0:59")
                .font(.system(size: 96, weight: .semibold))
            Button {
                print("stop")
            } label: {
                Circle()
                    .foregroundStyle(.black)
                    .overlay {
                        Image(systemName: "play.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(.leading)
                            .frame(minWidth: 40, maxWidth: 60)
                            .foregroundStyle(.white)
                            
                    }
            }
            .frame(minWidth: 40, maxWidth: 140)
            Spacer()
            Grid(alignment: .center) {
                GridRow {
                    VStack(alignment: .leading) {
                        Text("Speed")
                            .font(.system(size: 24))
                            .foregroundStyle(.blue)
                        Text("7.2 km/h")
                            .font(.system(size: 36))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Speed")
                            .font(.system(size: 24))
                            .foregroundStyle(.blue)
                        Text("7.2 km/h")
                            .font(.system(size: 36))
                    }
                }
                Spacer()
                GridRow {
                    VStack(alignment: .leading) {
                        Text("Speed")
                            .font(.system(size: 24))
                            .foregroundStyle(.blue)
                        Text("7.2 km/h")
                            .font(.system(size: 36))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Speed")
                            .font(.system(size: 24))
                            .foregroundStyle(.blue)
                        Text("7.2 km/h")
                            .font(.system(size: 36))
                    }
                }
            }
            .padding(.bottom)
        }
        .navigationTitle("\(workout.difficulty.level) Workout")
    }
}

#Preview {
    NavigationStack {
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
}

