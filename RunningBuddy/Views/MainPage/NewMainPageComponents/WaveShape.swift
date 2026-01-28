//
//  WaveShape.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.01.26.
//

import SwiftUI

struct Wave: Shape {
    var strength: Double
    var frequency: Double
    var phase: Double
    
    var animatableData: Double {
        get {phase}
        set {self.phase = newValue}
        
    }
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        let width = Double(rect.width)
        let heigth = Double(rect.height)
        let midWidth: Double = width / 2
        let midHeight: Double = heigth / 2
        let oneOverMidWidth = 1 / midWidth
        
        let waveLength = width / frequency
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / waveLength
            let distanceFromMidWidth = x - midWidth
            let normalDistance = oneOverMidWidth * distanceFromMidWidth
            let parabola = normalDistance
            let sine = sin(relativeX + phase)
            let y = parabola * strength * sine + midHeight
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: -heigth))
        path.addLine(to: CGPoint(x: 0, y: -heigth))
        path.close()
        
        return Path(path.cgPath)
        
    }
    
    
}


#Preview {
    ZStack {
        Wave(strength: 30, frequency: 10, phase: 10)
            .stroke(Color.black, lineWidth: 3)
        Wave(strength: 30, frequency: 10, phase: 5)
            .stroke(Color.green, lineWidth: 3)
    }
}


