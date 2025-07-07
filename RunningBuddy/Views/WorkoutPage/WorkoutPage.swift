//
//  WorkoutPage.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI

struct WorkoutPage: View {
    @StateObject var vm = WorkoutViewModel()
    @State private var path = NavigationPath()
    @Environment(\.managedObjectContext) var context
    var body: some View {
        NavigationStack(path: $path)  {
            VStack {
                Text(vm.selectedWorkout.difficulty.image)
                    .font(.system(size: 200))
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                    .background {
                        vm.selectedWorkout.difficulty.color
                            .animation(.easeInOut)
                            .ignoresSafeArea()
                    }
                Group {
                    Picker("selection of difficulty", selection: $vm.selectedIndex) {
                        ForEach(vm.workoutArray.indices, id: \.self) { index in
                            Text(vm.workoutArray[index].difficulty.level)
                        }
                    }
                    .pickerStyle(.segmented)
                    if let startingBlock = vm.startingBlock, let endBlock = vm.endBlock {
                        WorkoutDetails {
                            AnyView(
                                WorkoutSection(repeats: 0, {
                                    Text("^[\(Int(startingBlock.time / 60)) minutes](inflect: true) \(startingBlock.type.rawValue)")
                                        .contentTransition(.numericText())
                                    
                                })
                            )
                        } centerView: {
                            AnyView (
                                WorkoutSection(repeats: vm.numberOfRepeats, {
                                    VStack(alignment: .leading) {
                                        ForEach(vm.mainBlock, id: \.self) { section in
                                            Text("^[\(Int(section.time / 60)) minutes](inflect: true) \(section.type.rawValue)")
                                        }
                                    }
                                })
                                .contentTransition(.numericText())
                            )
                        } finishView: {
                            AnyView(
                                WorkoutSection(repeats: 0, {
                                    Text("^[\(Int(endBlock.time / 60)) minutes](inflect: true) \(endBlock.type.rawValue)")
                                })
                            )
                        }
                    } else {
                        Spacer()
                    }
                }
                .padding(.all)
                NavigationLink(value: vm.selectedWorkout){
                    Text("Start \(vm.time / 60) Min Workout")
                        .foregroundStyle(.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                        }
                        .contentTransition(.numericText())
                }
                .navigationDestination(for: WorkoutModel.self, destination: { workout in
                    Training(workout: workout, path: $path)
                })
            }
        }

        .onAppear(perform: {
            vm.calculateTime(vm.selectedWorkout)
            vm.getWorkoutData(vm.selectedWorkout)
        })
        .onChange(of: vm.selectedWorkout) { oldValue, newValue in
            vm.calculateTime(vm.selectedWorkout)
            vm.getWorkoutData(vm.selectedWorkout)
        }
        
    }
}

#Preview {
    NavigationStack {
        WorkoutPage()
    }
}
