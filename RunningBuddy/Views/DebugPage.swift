//
//  DebugPage.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 09.02.26.
//

import SwiftUI


struct DebugPage: View {
    enum DebugForm: Hashable {
        case distance
        case pace
        case time
        case date
    }
    
    @State private var selectedType: WorkoutType = .outdoorRun
    @State var distance: Double?
    @State var duration: Int?
    @State var pace: Double?
    @State var date: Date = Date.now
    
    @FocusState var focusField: DebugForm?

    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Create Workout")
                    Spacer()
                }
                
                Picker("Тип тренировки", selection: $selectedType) {
                    ForEach(WorkoutType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                Form {
                    TextField("Time", value: $duration, format: .number)
                        .focused($focusField, equals: .time)
                        .keyboardType(.numberPad)
                    TextField("Distance", value: $distance, format: .number)
                        .focused($focusField, equals: .distance)
                        .keyboardType(.numberPad)
                    TextField("Pace", value: $pace, format: .number)
                        .focused($focusField, equals: .pace)
                        .keyboardType(.numberPad)
                    DatePicker("Date", selection: $date)
                        .focused($focusField, equals: .date)
                }
                .toolbar {
                    ToolbarItem(placement: .title) {
                        Button {
                            focusField = nil
                        } label: {
                            Text("Done")
                        }

                    }
                }
                
                Spacer()
                Button {
                    guard let distance, let duration, let pace else { return }
                    let tempWorkout = WorkoutResultsModel(pace: pace, distance: distance, duration: duration, path: [], calories: 10, avgHeartRate: 11, maxHeartRate: 12, type: .outdoorRun)
                    
                    WorkoutProvider.shared.createWorkout(workout: tempWorkout, date: date)
                    
                    print("saved")
                } label: {
                    Text("Save workout")
                        .tint(.black)
                        .padding()
                        .glassEffect(in: .rect(cornerRadius: 16.0))
                }

                
            }
            .padding()
        }
    }
}


#Preview {
    DebugPage()
}

