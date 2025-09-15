//
//  OnboardingRoot.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 01.09.25.
//

import SwiftUI
import HealthKitUI
struct OnboardingRoot: View {
    @State var vm = OnbnoardingViewModel()
    var body: some View {
        TabView {
            Hello()
            Tutorial()
            PermissionView(viewModel: $vm, title: "Let’s find your moves 🌍✨", explanation: "To track your walks, runs, or rides we need access to your location. This way we can map your adventures, measure progress, and cheer you on wherever you go 🚴‍♂️🏃‍♀️🚶"){
                PermisionsButton(title: "Location", isGranted: $vm.locationGranted) {
                        if  LocationManager.shared.grantPermission() {
                            vm.locationGranted = true
                        }
                    }
            }
            .onReceive(LocationManager.shared.$isPermissionsGranted) { output in
                vm.locationGranted = output
            }
            PermissionView(viewModel: $vm, title: "High five for Health 🙌", explanation: "Connect Apple Health (and Apple Watch) to sync steps and workouts. Keep everything in one place and get insights to celebrate every move"){
                PermisionsButton(title: "Activity", isGranted: $vm.healthKitGranted) {
                    HealthKitManager.shared.ensuresHealthKitSetup()
                    vm.healthKitTrigger.toggle()
                    
                }
                .healthDataAccessRequest(store: vm.healKitManager.healthStore, readTypes: vm.healKitManager.activityTypes, trigger: vm.healthKitTrigger) { result in
                    switch result {
                    case .success(let resultValue):
                        vm.healthKitGranted = resultValue
                    case .failure(_):
                        vm.healthKitGranted = false
                    }
                }
            }
            
            
            
            End()
                .environment(vm)
            
        }
        .tabViewStyle(.page)
                
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                vm.animationToggle.toggle()
            }
        }
    }
}

#Preview {
    OnboardingRoot()
}
