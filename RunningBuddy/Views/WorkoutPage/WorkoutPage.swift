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
                    Face(emotion: $vm.selectedEmotion, color: .green)
                        .frame(maxWidth: .infinity, maxHeight: geo.size.height * (1/4))
                    Spacer()
                    WorkoutMaps(vm: $vm)
                        .padding(.top, 100)
                        .padding(.all)
//                    Spacer()
                    ScrollingButtons(selectedType: $vm.selectedDifficulty, scrollId: $vm.selectedEmotion, workoutTypes: vm.dificultyArray) {
                        path.append(vm.selectedWorkout)
                    }
                    .onChange(of: vm.selectedEmotion, { oldValue, newValue in
                        let index = vm.dificultyArray.firstIndex(where: { $0.image == newValue })
                        vm.selectedIndex = index ?? 0

                        
                        
                    })
                    .frame(height: 100)
                    .navigationDestination(for: WorkoutModel.self, destination: { workout in
                        Training(workout: workout, path: $path)
                    })
                }
            }
        }
        
        .onAppear(perform: {
            vm.calculateTime(vm.selectedWorkout)
            vm.getWorkoutData(vm.selectedWorkout)
        })
        .onChange(of: vm.selectedWorkout) { oldValue, newValue in
            vm.calculateTime(vm.selectedWorkout)
            vm.getWorkoutData(vm.selectedWorkout)
            vm.selectedEmotion = vm.selectedWorkout.difficulty.image
        }
        
    }
}

#Preview {
    NavigationStack {
        WorkoutPage()
    }
}
