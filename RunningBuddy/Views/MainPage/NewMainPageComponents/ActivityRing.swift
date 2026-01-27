//
//  ActivityRing.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 27.01.26.
//

import SwiftUI

struct ActivityRing: View {
    var max: Int = 100
    var min: Int = 0
    @Binding var value: Double
    private var pointer: Double {
        value + 0.04
    }
    
    private var gap: Double {
        pointer + 0.01
    }
    
   
    var body: some View {
        ZStack {
            
            
            Circle()
                .trim(from: 0, to: value)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .shadow(color: .red, radius: 1.5)
                .rotationEffect(Angle(degrees: 90))
            
            
            Circle()
                .trim(from: pointer, to: gap)
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(Angle(degrees: 90))
            Circle()
                .trim(from: gap + 0.04, to: 1 - 0.04)
                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(Angle(degrees: 90))
            Text("71")
                .padding()
                .frame(width: 50)
        }
        
            
            
    }
}

#Preview {
    
    ActivityRing(value: .constant(0.5))
}
