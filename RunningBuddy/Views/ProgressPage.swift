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
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("For \(vm.callout)")
                    .font(.callout)
                Picker("Choise options to filter on",selection: $vm.selectedChip) {
                    ForEach(vm.pickerOptions, id: \.self) { selection in
                        Text(selection.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                ProgressGraph(title: "Steps Count", progress: vm.stepsCount, interval: vm.selectedChip, data: $vm.steps)
                ProgressGraph(title: "Steps Count", progress: vm.stepsCount, barColor: .red, interval: vm.selectedChip, data: $vm.steps)
                ProgressGraph(title: "Steps Count", progress: vm.stepsCount, barColor: .yellow, interval: vm.selectedChip, data: $vm.steps)
                Spacer()
            }
            .padding()
            .navigationTitle("Progress")
            .onAppear {
                Task {
                    await vm.fetchWorkouts()
                    await vm.changeCalloutText()
                    await vm.getStepsForDuration(selectedChip: vm.selectedChip)
                    await vm.setStepsLabel()
                }
            }
            
        }
    }
}
//
//#Preview {
//    NavigationStack {
//        ProgressPage()
//    }
//}
