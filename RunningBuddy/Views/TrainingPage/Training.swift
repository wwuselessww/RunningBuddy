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
                StatDisplay(title: "Current objective time", value: "00:00", unit: "min")
                Text("Walk")
                    .font(Font.system(size: 54, weight: .bold, design: .default))
                    .bold()
                Text("next will be running")
                    .foregroundStyle(.gray)
//                    .padding(.bottom)
                Button {
                    vm.isPaused.toggle()
                } label: {
                    vm.image
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.black)
                        .frame(minWidth: 44, maxWidth: 88, minHeight: 44, maxHeight: 88)
                }
                Spacer()
            }
            if vm.isActivityInProgress {
                VStack {
                    Spacer()
                    Text("10%")
                        .font(.caption)
                    Rectangle()
                        .cornerRadius(10)
                        .frame(width: 30, height: 400)
                    
                }
                .ignoresSafeArea()
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
        .onReceive(vm.timer, perform: { value in
            guard vm.isActive else { return }
            withAnimation {
                vm.timerDisplay -= 1
                vm.totalTime -= 1
                vm.getSpeed()
                vm.getPace()
            }
        })
        
        .alert(vm.alertText, isPresented: $vm.showAlert, actions: {
            Button("ok", role: .cancel) {
                
            }
        })
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
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        Training(workout: .init(difficulty: .init(level: "Easy", image: "🥰", color: .blue),
                                start: Activity(time: 5*60, type: .walking, repeats: 0),
                                core: [
                                    Activity(time: 1*60, type: .running),
                                    Activity(time: 2*60, type: .walking),
                                    Activity(time: 6*60, type: .running),
                                    Activity(time: 2*60, type: .walking),
                                ], coreRepeats: 1,
                                end: Activity(time: 5*60, type: .walking)), path: $path
        )
    }
}

