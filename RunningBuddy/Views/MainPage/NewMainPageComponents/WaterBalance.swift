//
//  WaterBalance.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 27.01.26.
//

import SwiftUI

struct WaterBalance: View {
    @Binding var waterBalance: Double
    @Binding var title: Int
    @State private var phase: Double = 0
    var strength: Double = 0.5
    var frequency: Double = 0.5
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.gray.opacity(0.2))
            GeometryReader { geo in
                Wave(strength: 10, frequency: 3, phase: phase)
                    .fill(Color.blue)
                    .frame(height: geo.size.height * waterBalance)
                //min 0.5
                //max 1.5
            }
            .rotationEffect(.degrees(180))
            Text(title.description)
                .font(.caption.bold())
        }
        .clipShape (Circle())
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}
