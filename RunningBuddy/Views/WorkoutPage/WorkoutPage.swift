//
//  WorkoutPage.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI

struct WorkoutPage: View {
    @State var vm = WorkoutViewModel()
    @State private var path = NavigationPath()
    @Environment(\.managedObjectContext) var context
    var body: some View {
        NavigationStack(path: $path)  {
            GeometryReader { geo in
                VStack {
                    Picker("Type", selection: $vm.selectedType) {
                        ForEach(WorkoutType.allCases) { type in
                            Text(type.displayName)
                        }
                    }
                    .pickerStyle(.segmented)

                    
                    Face(emotion: $vm.selectedEmotion, color: vm.backgroundColor)
                        .frame(maxWidth: .infinity, maxHeight: geo.size.height * (1/4))
                    Spacer()
                    if vm.selectedType == .outdoorRun {
                        WorkoutMaps(vm: $vm)
                            .padding(.all)
                            .background {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                    
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(lineWidth: 3)
                                        .foregroundStyle(.black)
                                }
                                .foregroundStyle(.white)
                                .opacity(0.5)
                            }
                            .padding(.top, 100)
                            .padding(.all)
                        ScrollingButtons(selectedType: $vm.selectedDifficulty, scrollId: $vm.selectedEmotion, workoutTypes: vm.dificultyArray, time: vm.time) {
                            path.append(vm.selectedWorkout)
                        }
                        .onChange(of: vm.selectedEmotion, { oldValue, newValue in
                            guard let index = vm.dificultyArray.firstIndex(where: { $0.image == newValue }) else {
                                print("no index")
                                return
                            }
                            vm.selectedIndex = index
                            vm.backgroundColor = vm.dificultyArray[index].color
                        })
                        .frame(height: 100)
                        
                    } else {
                        VStack {
                            Spacer()
                            WalkDurationPicker(selectedTime: $vm.time, height: 10) {
                                vm.createWalkingWorkout()
                                path.append(vm.workoutWalk)
                            }
                        }
                        .padding(.top, 60)
                    }
                }
                .navigationDestination(for: WorkoutModel.self, destination: { workout in
                    Training(workout: workout, path: $path)
                })
                .padding()
                .background {
                    vm.backgroundColor
                        .opacity(0.7)
                        .ignoresSafeArea()
                }
            }
        }
        
        .onAppear(perform: {
            vm.calculateTime(vm.selectedWorkout)
            vm.getWorkoutData(vm.selectedWorkout)
            vm.changeWorkoutType(vm.selectedType)
        })
        .onChange(of: vm.selectedWorkout) { _, newValue in
            vm.calculateTime(newValue)
            vm.getWorkoutData(newValue)
            vm.selectedEmotion = newValue.difficulty.image
        }
        .onChange(of: vm.selectedType) { _, newValue in
            vm.changeWorkoutType(newValue)
        }
        
    }
}

#Preview {
    NavigationStack {
        WorkoutPage()
    }
}
