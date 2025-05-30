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
            //FIXME: while animation is running the numers are moving horisontally
            Text("\(vm.timerDisplay)")
                .contentTransition(.numericText())
                .font(.system(size: 96, weight: .semibold))
                .frame(minWidth: 200, maxWidth: .infinity, alignment: .center)
                .onReceive(vm.timer) { input in
                    guard vm.isActive else {return}
                    withAnimation {
                        vm.getTimeDifference(from: vm.now, to: vm.plusSecond)
                    }
                }
            Button {
                vm.isPlayPausePressed.toggle()
                if vm.isPlayPausePressed {
                    print("play")
                    vm.startTimer()
                } else {
                    print("stop")
                    vm.stopTimer()
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
            Spacer()
            Grid(alignment: .leading) {
                GridRow {
                    TrainingDetail(title: "Speed", metric: .constant(7.2), unitOfMeasurement: "km/h")
                    Spacer()
                    TrainingDetail(title: "Pace", metric: .constant(7.2), unitOfMeasurement: "min/h")
                }
                Spacer()
                GridRow {
                    TrainingDetail(title: "Time remaining", metric: .constant(7.2), unitOfMeasurement: "min")
                    Spacer()
                    TrainingDetail(title: "Total Distance", metric: .constant(7.2), unitOfMeasurement: "km")
                }
            }
            .padding(.bottom)
        }
        .onAppear {
            vm.workout = workout
            vm.stopTimer()
        }
        .onChange(of: vm.schenePhase, { oldValue, newValue in
            if vm.schenePhase == .active {
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

