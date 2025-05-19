//
//  WorkoutCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.05.25.
//

import SwiftUI
import HealthKit

struct WorkoutCell: View {
//    var workoutType: WorkoutType
    var workoutModel: WorkoutModel
    var body: some View {
        HStack {
            Image(systemName: workoutModel.type == .outdoorRun ? "figure.run": "figure.walk")
                .resizable()
                .scaledToFit()
                .frame(minWidth: 40, maxWidth: 60, minHeight: 40, maxHeight: 60)
            VStack(alignment: .leading) {
                Text("Outdoor Run")
                    .font(.system(size: 24))
                    .fontDesign(.rounded)
                Text("\(String(format: "%.1f", workoutModel.distance))km")
                    .font(.system(size: 24))
                    .fontDesign(.rounded)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Avg")
                    .font(.system(size: 20))
                    .fontDesign(.rounded)
                + Text(Image(systemName: "heart"))
                    .font(.system(size: 20))
                    .fontDesign(.rounded)
                    .foregroundStyle(.red)
                + Text ("\(workoutModel.avgPulse)")
                    .font(.system(size: 20))
                    .fontDesign(.rounded)
                Text("\(workoutModel.date.formateToString())")
                    .font(.system(size: 20))
                    .fontDesign(.rounded)
            }
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    NavigationStack {
        VStack {

            List {
                WorkoutCell(workoutModel: WorkoutModel(workout: HKWorkout(activityType: .archery, start: Date(), end: Date().advanced(by: 10)), date: Date(), distance: 0.0, avgPulse: 10, type: .outdoorRun))
            }
        }
    }
}
