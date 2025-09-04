//
//  MeshBackground.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 01.09.25.
//

import SwiftUI

struct MeshBackground: View {
    @Binding var isAnimating: Bool
    let color1: Color
    let color2: Color
    let color3: Color
    var body: some View {
        MeshGradient(width: 3, height: 3, points: [
            .init(0, 0), .init(0.5, 0), .init(1, 0),
            .init(0, 0.5), .init(isAnimating ? 0.1 : 0.8, 0.5), .init(1, 0.5),
            .init(0, 1), .init(0.5, 1), .init(1, 1)
        ], colors: [
            isAnimating ? color1 : color2, color1, isAnimating ? color3 : color2,
            color1, color2, isAnimating ? color3 : color1,
            isAnimating ? color3 : color2, color1, isAnimating ? color1 : color2
        ])
        .ignoresSafeArea()
    }
}


struct MeshBackgroundModifier: ViewModifier {
    @Binding var isAnimating: Bool
    let color1: Color
    let color2: Color
    let color3: Color
    func body(content: Content) -> some View {
        content
            .background(MeshBackground(isAnimating: $isAnimating, color1: color1, color2: color2, color3: color3))
            
    }
}

extension View {
    func meshBackground(isAnimating: Binding<Bool>, color1: Color, color2: Color, color3: Color) -> some View {
        self.modifier(MeshBackgroundModifier(isAnimating: isAnimating, color1: color1, color2: color2, color3: color3))
    }
}

#Preview {
    MeshBackground(isAnimating: .constant(true), color1: .orange, color2: .yellow, color3: .blue)
}
