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
    init(healthKitModel: HKWorkoutModel? = nil) {
        self.workoutModel = healthKitModel
    }
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        if let healkitModel = workoutModel {
            if !sizeCategory.isAccessibilityCategory {
                HStack {
                    Image(systemName: healkitModel.type == .outdoorRun ? "figure.run": "figure.walk")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 40, maxWidth: 60, minHeight: 40, maxHeight: 60)
                    VStack(alignment: .leading) {
                        Text("Outdoor Run")
                            .font(.title)
                            .fontDesign(.rounded)
                        Text("\(String(format: "%.1f", healkitModel.distance))km")
                            .font(.title)
                            .fontDesign(.rounded)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        if let bpm = healkitModel.avgPulse {
                            Text("Avg")
                                .font(.title3)
                                .fontDesign(.rounded)
                            + Text(Image(systemName: "heart"))
                                .font(.title3)
                                .fontDesign(.rounded)
                                .foregroundStyle(.red)
                            + Text ("\(bpm)")
                                .font(.title3)
                                .fontDesign(.rounded)
                        }
                        Text("\(healkitModel.date.formateToString())")
                            .font(.title3)
                            .fontDesign(.rounded)
                    }
                }
                .foregroundStyle(Color.label)
            } else {
                VStack(alignment: .trailing) {
                    Text(healkitModel.type.rawValue)
                        .font(.title)
                        .fontDesign(.rounded) +
                    Text(" \(String(format: "%.1f", healkitModel.distance))km")
                        .font(.title)
                        .fontDesign(.rounded)
                    VStack(alignment: .trailing) {
                        if let bpm = healkitModel.avgPulse {
                            Text("Avg")
                                .font(.title3)
                                .fontDesign(.rounded)
                            + Text(Image(systemName: "heart"))
                                .font(.title3)
                                .fontDesign(.rounded)
                                .foregroundStyle(.red)
                            + Text ("\(bpm)")
                                .font(.title3)
                                .fontDesign(.rounded)
                        }
                        Text("\(healkitModel.date.formateToString())")
                            .font(.title3)
                            .fontDesign(.rounded)
                    }
                }
                }
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
