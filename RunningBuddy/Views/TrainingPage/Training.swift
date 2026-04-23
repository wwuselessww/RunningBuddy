//
//  Training.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI

struct Training: View {
    @State var vm = TrainingViewModel()
    @Environment(\.dismiss) var dismiss
    var workout: WorkoutModel
    @Binding var path: NavigationPath
    let maxButtonSize: CGFloat = 66
    var body: some View {
        GeometryReader { geo in
            HStack {
                VStack(spacing: .zero) {
                    HStack {
                        StatDisplay(title: LocalizedStringKey("Time remaining"), value: Double(vm.totalTime).timeString(), unit: LocalizedStringKey("min"))
                        StatDisplay(title: LocalizedStringKey("Distance"), value: String(format: "%0.2f", vm.distance), unit: LocalizedStringKey("km"))
                    }
                    HStack {
                        StatDisplay(title: LocalizedStringKey("Pace"), value: String(format: "%0.1f", vm.pace), unit: LocalizedStringKey("km"))
                        StatDisplay(title: LocalizedStringKey("Speed"), value: String(format: "%0.1f", vm.speed), unit: LocalizedStringKey("km/h"))
                    }
                    StatDisplay(title: LocalizedStringKey("Current objective time"), value: Double(vm.currentObjectiveTime).timeString(), unit: LocalizedStringKey("min"))
                    Text(vm.currentAcitivity?.type.localizedName ?? "Walk")
                        .font(Font.system(size: 44, weight: .bold, design: .default))
                        .bold()
                    Spacer()
                    HStack {
                        if !vm.isPaused {
                            Button {
                                print("exit")
                                vm.backPressed()
                            } label: {
//                                Text("End")
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .circleButtonStyle(color: .red)
                                    .frame(minWidth: 44, maxWidth: maxButtonSize, minHeight: 44, maxHeight: maxButtonSize)
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
                                .foregroundStyle(.label)
                                .frame(minWidth: 44, maxWidth: 88, minHeight: 44, maxHeight: 88)
                        }
                        if !vm.isPaused {
                            Button {
                                print("skip")
                                vm.skipHolded()
                            } label: {
                                Image(systemName: "forward.fill")
                                    .resizable()
                                    .scaledToFit()
//                                Text("Skip")
                                    .foregroundStyle(.white)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .circleButtonStyle(color: .blue)
                                    .frame(minWidth: 44, maxWidth: maxButtonSize, minHeight: 44, maxHeight: maxButtonSize)
                            }
                        }
                    }
                    Spacer()
                }
                if !vm.firstStart {
                    VStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("\(vm.progressText)%")
                                .font(.caption)
                            Rectangle()
                                .cornerRadius(10)
                            
                            
                        }
                        .ignoresSafeArea()
                        .frame(width: 30, height: vm.progressBarHeight)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
            .onReceive(vm.timer, perform: { value in
                guard vm.isActive else { return }
                vm.handleTimerOnRecive()
            })
            .navigationDestination(for: WorkoutResultsModel.self, destination: { workout in
                FinishWorkout(workout: workout, path: $path)
            })
            .alert(vm.alertText, isPresented: $vm.showAlert, actions: {
                Button("Ok", role: .cancel) {
                    vm.stopActivity()
                    guard let workoutResult = vm.workoutResult else {
                        print("no result")
                        return
                    }
                    path.append(workoutResult)
                }
                Button("Cancel", role: .destructive) {
                    vm.handleCancel()
                }
            }, message: {
                    Text("If you want to end the workout press 'Ok' and what was recorded will be saved.")
            })
            .onAppear {
                vm.workout = workout
                vm.createActivities()
                
                vm.stopTimer()
                vm.getTotalTime()
                vm.getCurrentActivityTime()
                vm.screenHeight = geo.size.height
                
                vm.currentAcitivityIndex = 0
                vm.currentAcitivity = vm.activities.first
            }
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        Training(workout: .init(difficulty: .init(level: "Easy", image: .easy, color: .blue), type: .running,
                                start: WorkoutActivity(time: 5*60, type: .walking, repeats: 0),
                                core: [
                                    WorkoutActivity(time: 1*10, type: .running),
                                    WorkoutActivity(time: 1*10, type: .walking),
                                    WorkoutActivity(time: 1*10, type: .running),
                                    WorkoutActivity(time: 2*60, type: .walking),
                                ], coreRepeats: 1,
                                end: WorkoutActivity(time: 5*60, type: .walking)), path: $path
        )
    }
}

