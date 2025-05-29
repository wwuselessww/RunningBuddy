//
//  WorkoutPage.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI

struct WorkoutPage: View {
    @StateObject var vm = WorkoutViewModel()
    var body: some View {
        VStack {
//            if let selectedWorkout = vm.selectedWorkout {
            Text(vm.selectedWorkout.difficulty.image)
                    .font(.system(size: 200))
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                    .background {
                        vm.selectedWorkout.difficulty.color
                            .animation(.easeInOut)
                            .ignoresSafeArea()
                    }
//            }
            Group {
                Picker("selection of difficulty", selection: $vm.selectedIndex) {
                    ForEach(vm.workoutArray.indices, id: \.self) { index in
                        Text(vm.workoutArray[index].difficulty.level)
                    }
                }
                .pickerStyle(.segmented)
                WorkoutDetails {
                    AnyView(
                        WorkoutSection(repeats: 0, {
                            Text("6 minutes Run")
                                
                        })
                    )
                } centerView: {
                    AnyView (
                        WorkoutSection(repeats: vm.numberOfRepeats, {
                            VStack(alignment: .leading) {
                                Text("4 minutes Run")
                                Text("2 minutes Walk")
                                Text("6 minutes Run")
                                Text("2 minutes Walk")
                            }
                        })
                        .contentTransition(.numericText())
                    )
                } finishView: {
                    AnyView(
                        WorkoutSection(repeats: 0, {
                            Text("6 minutes Run")
                        })
                    )
                }

                Button {
                    print("press")
                } label: {
                    Text("Start \(vm.time) Min Workout")
                        .foregroundStyle(.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                        }
                }

            }
            .padding(.all)
        }
        .onAppear(perform: {
            vm.calculateTime()
            vm.getWorkoutData()
        })
        .onChange(of: vm.selectedWorkout) { oldValue, newValue in
            vm.calculateTime()
            vm.getWorkoutData()
        }
        
    }
}

#Preview {
    WorkoutPage()
}
