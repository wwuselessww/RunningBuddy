//
//  HKPermisions.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 02.09.25.
//

import SwiftUI

struct PermissionView<Content: View>: View {
    @Binding var viewModel: OnbnoardingViewModel
    let title: String
    let explanation: String
    var content: () -> Content
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 100, height: 100)
                .overlay {
                    Text("CHANGE ME")
                        .foregroundStyle(.white)
                }
                .padding(.top)
            Text(title)
                .foregroundStyle(.label)
                .whiteRoundedText()
                .multilineTextAlignment(.center)
                .font(.title)
                .padding(.bottom, 5)
            Text(explanation)
                .foregroundStyle(.gray)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .padding(.bottom, 50)
                .padding(.horizontal)
            content()
                .padding(.bottom)
        }
        .padding(.all)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .padding()
        }
    }
}

#Preview {
    @Previewable @State var vm = OnbnoardingViewModel()
    PermissionView(viewModel: $vm, title: "High five for Health 🙌", explanation: "Connect Apple Health (and Apple Watch) to sync steps and workouts. Keep everything in one place and get insights to celebrate every move") {
        PermisionsButton(title: "Activity", isGranted: $vm.locationGranted) {
            vm.locationGranted.toggle()
        }
    }
}
