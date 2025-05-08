//
//  MainView.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 25.04.25.
//

import SwiftUI
import HealthKit
import HealthKitUI

struct MainPage: View {
    @ObservedObject var vm = MainPageViewModel()
    @State var authenticated: Bool = false
    @State var trigger: Bool = false
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
                ForEach(0..<vm.workoutArray.count, id: \.self) { index in
                    WorkoutCell(workoutModel: vm.workModelArray[index])
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
        .healthDataAccessRequest(store: vm.healtKitManager.healthStore, readTypes: vm.healtKitManager.activityTypes, trigger: trigger) { result in
            switch result {
            case .success(_):
                authenticated = true
            case .failure(let error):
                authenticated = false
                print(error.localizedDescription)
            }
        }
        .onAppear {
            trigger.toggle()
            vm.getActivity()
        }
    }
}
     
#Preview {
    MainPage()
}


