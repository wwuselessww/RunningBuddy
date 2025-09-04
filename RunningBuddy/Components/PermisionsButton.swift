//
//  PermisionsButton.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 01.09.25.
//

import SwiftUI
struct PermisionsButton: View {
    let title: String
    @Binding var isGranted: Bool
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: isGranted ? "checkmark.seal.fill" : "xmark.seal.fill")
                    .foregroundStyle( isGranted ? .green : .red)
                Spacer()
                Text(title.capitalized)
                    .foregroundStyle(.label)
                    .whiteRoundedText()
                    
                Spacer()
            }
            .frame(width: 150)
            .padding()
            .background {
                Capsule()
                    .foregroundStyle(.thinMaterial)
            }
        }
    }
}


#Preview {
    PermisionsButton(title: "Location", isGranted: .constant(false)) {
        print("hehe")
    }
}
