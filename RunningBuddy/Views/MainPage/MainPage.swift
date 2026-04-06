//
//  NewMainPage.swift
//  RunningBuddy
//
//  
//

import SwiftUI

struct MainPage: View {
    @State private var path = NavigationPath()
    @State var viewModel = MainPageViewModel()
    @State private var offset: CGFloat = 0
    
    private let maxOffset: CGFloat = 80
    @GestureState var translation: CGFloat = 0
    
    var body: some View {
            VStack {
                WeekHeader(waterLevel: $viewModel.waterLevel, waterTitle: $viewModel.waterTitle, days: $viewModel.days, chosenDay: $viewModel.chosenDay, activityValue: $viewModel.activityValue, activityTitle: $viewModel.activityTitle)
                    if !viewModel.hkWorkouts.isEmpty {
                        ScrollView {
                            ForEach(viewModel.hkWorkouts, id: \.id) { workout in
                                WorkoutCell(model: workout)
                                    .padding(.all)
                                    .frame(minWidth: 300, maxWidth: .infinity, minHeight: 500, maxHeight: 500)
                            }
                            .scrollClipDisabled()
                            Spacer()
                        }
                    } else {
                        Spacer()
                        NoActivityPlaceholder()
                        Spacer()
                    }
                
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
                viewModel.updateView()
            }
            .onChange(of: viewModel.chosenDay) { oldValue, newValue in
                viewModel.setDateTo(newValue)
                viewModel.updateView()
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
    NavigationStack {
        MainPage()
    }
}
#Preview("iPhone SE-ish", traits: .fixedLayout(width: 375, height: 667)) {
    NavigationStack {
        MainPage()
    }
}

#Preview("iPhone 16 Pro-ish", traits: .fixedLayout(width: 393, height: 852)) {
    NavigationStack {
        MainPage()
    }
}

