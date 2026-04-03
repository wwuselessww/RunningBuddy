//
//  BeanMouth.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 16.03.26.
//

import SwiftUI

struct BeanMouth: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        path.addArc(
            center: center,
            radius: rect.width * 0.35,
            startAngle: .degrees(20),
            endAngle: .degrees(160),
            clockwise: false
        )
        return path
    }
}


#Preview {
    BeanMouth()
        .stroke(
            Color.red,
            style: StrokeStyle(
                lineWidth: 28,
                lineCap: .round 
            )
        )
        .frame(width: 120, height: 60)
}
