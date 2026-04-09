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
            PermissionView(
                viewModel: $vm,
                title: "Map your every move",
                explanation: "We need location access to track your walks, runs, and rides — so we can map your routes and measure your progress."
            ) {
                PermisionsButton(title: "Location", isGranted: $vm.locationGranted) {
                    if LocationManager.shared.grantPermission() {
                        vm.locationGranted = true
                    }
                }
            }
            .onReceive(LocationManager.shared.$isPermissionsGranted) { output in
                vm.locationGranted = output
            }
            PermissionView(
                viewModel: $vm,
                title: "Sync your activity",
                explanation: "Connect Apple Health and Apple Watch to keep your steps and workouts in one place."
            ) {
                PermisionsButton(title: "Activity", isGranted: $vm.healthKitGranted) {
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
            WeightView(selectedWeight: $vm.weight)
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
