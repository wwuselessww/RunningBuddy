//
//  NewMainPage.swift
//  RunningBuddy
//
//  
//

import SwiftUI

struct NewMainPage: View {
    @State private var path = NavigationPath()
    @State var viewModel = NewMainPageViewModel()
    
    var body: some View {
            VStack {
                WeekHeader(waterLevel: $viewModel.waterLevel, waterTitle: $viewModel.waterTitle, days: $viewModel.days, chosenDay: $viewModel.chosenDay, activityValue: $viewModel.activityValue, activityTitle: $viewModel.activityTitle)
                ScrollView {
                    if !viewModel.hkWorkouts.isEmpty {
                        ForEach(0..<viewModel.hkWorkouts.count, id: \.self) { i in
                            NewWorkoutCell(model: viewModel.hkWorkouts[i])
                                .padding(.all)
                                .frame(minWidth: 300, maxWidth: .infinity, minHeight: 500, maxHeight: 500)
                        }
                    }
                }.scrollClipDisabled()
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            .healthDataAccessRequest(store: viewModel.healtKitManager.healthStore, readTypes: viewModel.healtKitManager.activityTypes, trigger: viewModel.trigger) { result in
                switch result {
                case .success(_):
                    viewModel.authenticated = true
                case .failure(let error):
                    viewModel.authenticated = false
                    print(error.localizedDescription)
                }
            }
            
            .onAppear {
                viewModel.trigger.toggle()
                viewModel.getPhoneRecordedWorkouts()
                viewModel.getWorkouts()
                print(" ")
                print("array here ", viewModel.phoneRecordedWorkouts)
                print(" ")
            }
    }
}


struct Days: Identifiable {
   let id: UUID = UUID()
    var name: String
    var number: Int
    var isSelected: Bool = false
}

#Preview {
    NewMainPage()
}
