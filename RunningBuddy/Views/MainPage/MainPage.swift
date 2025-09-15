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
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            VStack{
                Header(distance: $vm.totalMonthDistance)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 10)
                List {
                    if !vm.workModelArray.isEmpty {
                        Section(header: Text("Workouts")) {
                            ForEach(0..<vm.workModelArray.count, id: \.self) { index in
                                Button {
                                    vm.didTapOnWorkout = true
                                    vm.currentIndex = index
                                } label: {
                                    WorkoutCell(healthKitModel: vm.workModelArray[index])
                                }
                            }
                            .onDelete(perform: vm.delete)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .healthDataAccessRequest(store: vm.healtKitManager.healthStore, readTypes: vm.healtKitManager.activityTypes, trigger: trigger) { result in
            switch result {
            case .success(_):
                authenticated = true
            case .failure(let error):
                authenticated = false
                print(error.localizedDescription)
            }
        }
        .sheet(isPresented: $vm.didTapOnWorkout) {
            let data = vm.workModelArray[vm.currentIndex]
            if data.recordedByPhone {
                WorkoutInfo(workoutModel: data)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            } else {
                WorkoutInfo(workoutModel: data)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
        
        .onAppear {
            trigger.toggle()
//            vm.phoneRecordedWorkouts = Array(workouts)
            vm.getPhoneRecordedWorkouts()
            vm.getActivity()
            print(" ")
            print("array here ", vm.phoneRecordedWorkouts)
            print(" ")
        }
    }
}

#Preview {
    NavigationStack {
        MainPage()
    }
}


