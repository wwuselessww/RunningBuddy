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
    @Environment(\.dismiss) var dismiss
    var workout: Workout
    var height = UIScreen.main.bounds.height
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            VStack(spacing: .zero) {
                HStack {
                    StatDisplay(title: "Time remaining", value: Double(vm.totalTime).timeString(), unit: "min")
                    StatDisplay(title: "Distance", value: String(format: "%0.2f", vm.distance), unit: "km")
                }
                HStack {
                    StatDisplay(title: "Pace", value: String(format: "%0.1f", vm.pace), unit: "km")
                    StatDisplay(title: "Speed", value: String(format: "%0.1f", vm.speed), unit: "km/h")
                }
                StatDisplay(title: "Current objective time", value: Double(vm.timerDisplay).timeString(), unit: "min")
                Text("Walk")
                    .font(Font.system(size: 44, weight: .bold, design: .default))
                    .bold()
                Text("next will be running")
                    .foregroundStyle(.gray)
                Spacer()
                HStack {
                    if !vm.isPaused {
                        Button {
                            print("exit")
                            vm.backPressed()
                        } label: {
                            Text("End")
                                .foregroundStyle(.white)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .circleButtonStyle(color: .red)
                        }
                    }
                    Button {
                        withAnimation {
                            vm.isPaused.toggle()
                        }
                        
                    } label: {
                        vm.image
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.black)
                            .frame(minWidth: 44, maxWidth: 88, minHeight: 44, maxHeight: 88)
                    }
                    if !vm.isPaused {
                        Button {
                            print("skip")
                            vm.skipHolded()
                        } label: {
                            Text("Skip")
                                .foregroundStyle(.white)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .circleButtonStyle(color: .blue)
                        }
                    }
                }
                Spacer()
            }
            if !vm.firstStart {
                VStack {
                    Spacer()
                    Text("\(vm.progressText)%")
                        .font(.caption)
                    Rectangle()
                        .cornerRadius(10)
                        .frame(width: 30, height: vm.progressBarHeight)
                    
                }
                .ignoresSafeArea()
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
        .onReceive(vm.timer, perform: { value in
            guard vm.isActive else { return }
            withAnimation {
                vm.checkActivity()
                vm.getSpeed()
                vm.getPace()
                vm.calculateProgress()
                vm.timerDisplay -= 1
                vm.totalTime -= 1
            }
        })
        .navigationDestination(for: WorkoutResultsModel.self, destination: { workout in
            FinishWorkout(isRecordedByWatch: false, workout: workout)
        })
        .alert(vm.alertText, isPresented: $vm.showAlert, actions: {
            Button("Ok", role: .cancel) {
                if vm.canProceed {
                    guard let workoutResult = vm.workoutResult else {return}
                    path.append(workoutResult)
                } else {
                    path.removeLast()
                }
            }
            Button("Cancel", role: .destructive) {
                vm.showAlert = falsex
            }
        })
        .onAppear {
            vm.workout = workout
            vm.createActivitiesArray()
            vm.currentAcitivityIndex = 0
            vm.currentAcitivity = vm.activities.first
            vm.stopTimer()
            vm.getTotalTime()
            vm.screenHeight = height
        }
        .onChange(of: schenePhase, { oldValue, newValue in
            if schenePhase == .active {
                vm.isActive = true
            } else {
                vm.isActive = false
            }
        })
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        Training(workout: .init(difficulty: .init(level: "Easy", image: "🥰", color: .blue),
                                start: Activity(time: 5*60, type: .walking, repeats: 0),
                                core: [
                                    Activity(time: 1*10, type: .running),
                                    Activity(time: 1*10, type: .walking),
                                    Activity(time: 1*10, type: .running),
                                    Activity(time: 2*60, type: .walking),
                                ], coreRepeats: 1,
                                end: Activity(time: 5*60, type: .walking)), path: $path
        )
    }
}

