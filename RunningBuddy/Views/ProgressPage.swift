//
//  ProgressPage.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI

struct ProgressPage: View {
    @StateObject var vm = ProgressViewModel()
    @State var navigationPath = NavigationPath()
    
    var data: [ActivityForGrid] {
        var array: [ActivityForGrid] = []
        for _ in 0..<31 {
            array.append(.init(isRecorded: Bool.random(), number: 1))
        }
        return array
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("For \(vm.callout)")
                    .font(.title3)
                Picker("Choise options to filter on",selection: $vm.selectedChip) {
                    ForEach(vm.pickerOptions, id: \.self) { selection in
                        Text(selection.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                ProgressGraph(
                    title: "Steps Count",
                    progress: vm.stepsCount,
                    interval: vm.selectedChip,
                    data: $vm.steps
                )
                ProgressGraph(
                    title: "Distance recorded by app in km",
                    progress: vm.distanceLabel,
                    barColor: .yellow,
                    interval: vm.selectedChip,
                    data: $vm.distance
                )
                Divider()
                    .padding(.vertical)
                
                VStack {
                    Text("\(vm.activitiesMonth) Activities")
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ActivityGrid(data: vm.activites, color: .red)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Progress")
            .onAppear {
                
                Task {

                    vm.workouts = await vm.fetchWorkoutsForSelected(vm.selectedChip)
                    await vm.changeCalloutText()
                    await vm.getStepsForDuration(selectedChip: .day)
                    await vm.setStepsLabel()
                    await vm.getWorkoutDistanceForDuration(selectedChip: .day)
                    await vm.populateActivites()
                    print("HERE !!!!!")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProgressPage()
    }
}
