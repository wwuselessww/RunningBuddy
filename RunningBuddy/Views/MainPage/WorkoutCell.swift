//
//  WorkoutCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.05.25.
//

import SwiftUI
import HealthKit

struct WorkoutCell: View {
    var workoutModel: HKWorkoutModel?
    var workout: Workout?
    
    init(healthKitModel: HKWorkoutModel? = nil, workout: Workout? = nil) {
        self.workoutModel = healthKitModel
        self.workout = workout
    }
    
    var body: some View {
        if let healkitModel = workoutModel {
            HStack {
                Image(systemName: healkitModel.type == .outdoorRun ? "figure.run": "figure.walk")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 40, maxWidth: 60, minHeight: 40, maxHeight: 60)
                VStack(alignment: .leading) {
                    Text("Outdoor Run")
                        .font(.system(size: 24))
                        .fontDesign(.rounded)
                    Text("\(String(format: "%.1f", healkitModel.distance))km")
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
                    + Text ("\(healkitModel.avgPulse)")
                        .font(.system(size: 20))
                        .fontDesign(.rounded)
                    Text("\(healkitModel.date.formateToString())")
                        .font(.system(size: 20))
                        .fontDesign(.rounded)
                }
            }
            .foregroundStyle(Color.label)
        } else if let workout = workout {
            HStack {
                Image(systemName: "figure.run")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 40, maxWidth: 60, minHeight: 40, maxHeight: 60)
                VStack(alignment: .leading) {
                    Text("Outdoor Run")
                        .font(.system(size: 24))
                        .fontDesign(.rounded)
                    Text("\(String(format: "%.1f", workout.distance))km")
                        .font(.system(size: 24))
                        .fontDesign(.rounded)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(workout.creationDate.formateToString())")
                        .font(.system(size: 20))
                        .fontDesign(.rounded)
                }
            }
            .foregroundStyle(.primary)
        }
    }
}

#Preview {
    NavigationStack {
        VStack {

            List {
                WorkoutCell(healthKitModel: HKWorkoutModel(workout: HKWorkout(activityType: .archery, start: Date(), end: Date().advanced(by: 10)), date: Date(), distance: 0.0, avgPulse: 10, type: .outdoorRun))
            }
        }
    }
}
