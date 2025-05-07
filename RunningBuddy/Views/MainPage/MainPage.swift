//
//  MainView.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 25.04.25.
//

import SwiftUI

struct MainPage: View {
    @ObservedObject var vm = MainPageViewModel()
    var body: some View {
        VStack {
            Header(distance: $vm.totalMonthDistance)
            ActivityBar(maxActivity: $vm.maxActivity, closedActivity: $vm.currentActivity)
                .padding(.bottom, 20)
            HStack {
                Text("Workouts")
                    .font(.system(size: 24))
                Spacer()
            }
            ScrollView {
                ForEach(0..<10, id: \.self) { _ in
                    WorkoutCell(workoutType: .outdoorRun)
                }
                
            }
            .scrollIndicators(.hidden)
                
            Button {
                vm.currentActivity += 100
                print(vm.currentActivity)
            } label: {
                Text("Add")
            }

            Spacer()
        }
        .padding(.horizontal, 10)
    }
}
#Preview {
    MainPage()
}


