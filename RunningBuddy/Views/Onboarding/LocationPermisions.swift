//
//  Permisions.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 01.09.25.
//

import SwiftUI

struct LocationPermisions: View {
    @Binding var viewModel: OnbnoardingViewModel
    var body: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 100, height: 100)
                .overlay {
                    Text("CHANGE ME")
                        .foregroundStyle(.white)
                }
            Text("We use your location to improve your experience")
                .foregroundStyle(.label)
                .whiteRoundedText()
                .multilineTextAlignment(.center)
                .font(.title)
                .padding(.bottom, 5)
            Text("Allow location access so we can measure your activities and provide accurate insights")
                .foregroundStyle(.gray)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .padding(.bottom, 50)
//            Spacer()
            PermisionsButton(title: "locations", isGranted: $viewModel.locationGranted) {
                viewModel.locationGranted.toggle()
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    @Previewable  @State var vm = OnbnoardingViewModel()
    LocationPermisions(viewModel: $vm)
}
