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
    @FetchRequest(fetchRequest: Workout.all()) private var workouts
    var body: some View {
        NavigationStack(path: $path) {
            VStack{
                Header(distance: $vm.totalMonthDistance)
                ActivityBar(maxActivity: $vm.maxActivity, closedActivity: $vm.currentActivity)
                    .padding(.bottom, 20)
                HStack {
                    Text("Workouts")
                        .font(.system(size: 24))
                    Spacer()
                }
                VStack (alignment: .leading) {
                    ScrollView {
                        Section(header: Text("Source: Apple watch")) {
                            ForEach(0..<vm.workoutArray.count, id: \.self) { index in
                                Button {
                                    vm.didTapOnWorkout = true
                                    vm.currentIndex = index
                                    print("vm.currentActivity", vm.currentActivity)
                                } label: {
                                    WorkoutCell(workoutModel: vm.workModelArray[index])
                                }
                                .sheet(isPresented: $vm.didTapOnWorkout) {
                                    WorkoutInfo(workoutModel: vm.workModelArray[vm.currentIndex])
                                        .presentationDragIndicator(.visible)
                                }
                                
                            }
                        }
                        Section(header: Text("Source: iPhone")) {
                            ForEach(workouts) { workout in
                                Text(workout.duration.description)
                                
                            }
                        }
                        
                    }
                    .scrollIndicators(.hidden)
                }
                Spacer()
            }}
        
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


