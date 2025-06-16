//
//  Training.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI

struct Training: View {
    @StateObject var vm = TrainingViewModel()
    @Environment(\.scenePhase) var schenePhase
    var workout: Workout
    var body: some View {
        VStack {
            HStack {
                ForEach(Array(vm.activities.enumerated()), id: \.offset) { index, part in
                    Circle()
                        .overlay(content: {
                            if let currentActivity = vm.currentAcitivity {
                                Image(systemName: part.type == .running ? "figure.run" : "figure.walk")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(part.id == currentActivity.id ? .white : .gray)
                                    .padding(.all, 5)
                            }
                        })
                        .frame(minWidth: 29, maxWidth: 40, minHeight: 29, maxHeight: 40)
                }
            }
            .padding(.horizontal)
            Spacer()
            Text(vm.currentAcitivity?.type.rawValue ?? "No activity")
                .font(.system(size: 40, weight: .semibold))
            //FIXME: while animation is running the numers are moving horisontally
            Text(vm.timeString(from: vm.timerDisplay))
                .contentTransition(.numericText())
                .font(.system(size: 96, weight: .semibold))
                .frame(minWidth: 200, maxWidth: .infinity, alignment: .center)
                .onReceive(vm.timer) { input in
                    guard vm.isActive else {return}
                    withAnimation {
                        vm.timerDisplay -= 1
                        vm.totalTime -= 1
                        vm.getSpeed()
                        vm.getPace()
                    }
                }
            HStack(alignment: .center) {
                Spacer()
                Button {
                    vm.isPlayPausePressed.toggle()
                    if vm.isPlayPausePressed {
                        print("play")
                        vm.startTimer()
                        vm.locationManager.startTracking()
                    } else {
                        print("stop")
                        vm.stopTimer()
                        vm.locationManager.stopTracking()
                    }
                } label: {
                    Circle()
                        .foregroundStyle(.black)
                        .overlay {
                            vm.image
                                .resizable()
                                .scaledToFit()
                            
                                .frame(minWidth: 40, maxWidth: 60)
                                .foregroundStyle(.white)
                            
                        }
                }
                .frame(minWidth: 40, maxWidth: 140)
                HoldToSkipButton(onHold: {
                    
                }, onHoldEnded: {
                    vm.skipHolded()
                })
                
            }
            Spacer()
            Grid(alignment: .leading) {
                GridRow {
                    TrainingDetail(title: "Speed", unitOfMeasurement: "km/h") {
                        Text(String(format: "%0.1f", vm.speed))
                    }
                    Spacer()
                    TrainingDetail(title: "Pace", unitOfMeasurement: "min/km") {
                        Text(String(format: "%0.1f", vm.pace))
                    }
                }
                Spacer()
                GridRow {
                    TrainingDetail(title: "Time remaining", unitOfMeasurement: "min", isTime: true) {
                        Text(vm.timeString(from: vm.totalTime))
                    }
                    Spacer()
                    TrainingDetail(title: "Total Distance",unitOfMeasurement: "km") {
                        Text("7.2")
                    }
                }
            }
            .padding(.bottom)
        }
        .onAppear {
            vm.workout = workout
            vm.createActivitiesArray()
            vm.currentAcitivityIndex = 0
            vm.currentAcitivity = vm.activities.first
            vm.stopTimer()
            vm.getTotalTime()
        }
        .onChange(of: schenePhase, { oldValue, newValue in
            if schenePhase == .active {
                vm.isActive = true
            } else {
                vm.isActive = false
            }
        })
        .navigationTitle("\(workout.difficulty.level) Workout")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        Training(workout: .init(difficulty: .init(level: "Easy", image: "🥰", color: .blue),
                                start: Activity(time: 5*60, type: .walking, repeats: 0),
                                core: [
                                    Activity(time: 1*60, type: .running),
                                    Activity(time: 2*60, type: .walking),
                                    Activity(time: 6*60, type: .running),
                                    Activity(time: 2*60, type: .walking),
                                ], coreRepeats: 1,
                                end: Activity(time: 5*60, type: .walking))
        )
        
    }
}

