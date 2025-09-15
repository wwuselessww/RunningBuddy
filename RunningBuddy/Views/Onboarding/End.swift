//
//  End.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 01.09.25.
//

import SwiftUI

struct End: View {
    @Environment(OnbnoardingViewModel.self) var vm
    var body: some View {
        VStack {
            if vm.errorText != "" {
                ErrorView(text: vm.errorText)
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: vm.errorText)
            }
            Spacer()
            Text("Now")
                .fontDesign(.rounded)
                .fontWeight(.bold)
                .font(Font.system(size: 40, weight: .bold, design: .rounded))
                .rotationEffect(.degrees(4))
            Text("lets get going!")
                .fontDesign(.rounded)
                .fontWeight(.bold)
                .font(Font.system(size: 30, weight: .bold, design: .rounded))
                .rotationEffect(.degrees(-3))
            Image(systemName: "figure.run")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                
            Spacer()
            
            Button {
                vm.isCompleted.toggle()
                vm.checkOnboardingCompletion()
            } label: {
                Text("Complete")
                    .whiteRoundedText()
                    .padding()
                    .background {
                        Capsule()
                    }
            }
            
        }
        .padding(.bottom, 60)
    }
}

#Preview {
    End()
        .environment(OnbnoardingViewModel())
}
