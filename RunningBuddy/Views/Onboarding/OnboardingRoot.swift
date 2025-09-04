//
//  OnboardingRoot.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 01.09.25.
//

import SwiftUI

struct OnboardingRoot: View {
    @State var vm = OnbnoardingViewModel()
    var body: some View {
        TabView {
            Hello()
            PermissionView(viewModel: $vm, title: "Let’s find your moves 🌍✨", explanation: "To track your walks, runs, or rides we need access to your location. This way we can map your adventures, measure progress, and cheer you on wherever you go 🚴‍♂️🏃‍♀️🚶"){
                PermisionsButton(title: "Location", isGranted: $vm.locationGranted) {
                    vm.locationGranted.toggle()
                }
            }
            PermissionView(viewModel: $vm, title: "High five for Health 🙌", explanation: "Connect Apple Health (and Apple Watch) to sync steps and workouts. Keep everything in one place and get insights to celebrate every move"){
                PermisionsButton(title: "Activity", isGranted: $vm.healthKitGranted) {
                    vm.healthKitGranted.toggle()
                }
            }
            
            
            //            Tutorial()
            //            End()
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
