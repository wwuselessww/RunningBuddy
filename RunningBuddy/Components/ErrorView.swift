//
//  ErrorView.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 15.09.25.
//

import SwiftUI

struct ErrorView: View {
    let text: String
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(.red)
            Text(text)
                .whiteRoundedText()
                .multilineTextAlignment(.center)
                .padding()
                .background {
                    Capsule()
                        .foregroundStyle(.gray)
                }
        }
    }
}

#Preview {
    ErrorView(text: "sd")
}
