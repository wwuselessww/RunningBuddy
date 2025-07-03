//
//  CircleButton.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 03.07.25.
//

import SwiftUI
struct CircleButtonModifier: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 44, maxWidth: 88, minHeight: 44, maxHeight: 88)
            .background {
                Circle()
                    .foregroundStyle(color)
            }
    }
}
extension View {
    func circleButtonStyle(color: Color) -> some View {
        modifier(CircleButtonModifier(color: color))
    }
}

#Preview(body: {
    Text("heh")
        .foregroundStyle(.white)
        .bold()
        .circleButtonStyle(color: .red)
    
})
