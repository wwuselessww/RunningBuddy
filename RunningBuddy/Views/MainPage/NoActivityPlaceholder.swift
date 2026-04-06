//
//  NoActivityPlaceholder.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 17.02.26.
//

import SwiftUI

struct NoActivityPlaceholder: View {
    var body: some View {
        VStack {
            ZStack {
                ActivityEmptyPlaceholder(systemImage: "figure.outdoor.cycle", title: "Cycling", color: .orange)
                    .rotationEffect(.degrees(-5))
                    .offset(x: -40, y: -40)
                ActivityEmptyPlaceholder(systemImage: "figure.walk", title: "Walking", color: .green)
                    .rotationEffect(.degrees(10))
                    .offset(x: 45, y: -25)
                ActivityEmptyPlaceholder(systemImage: "figure.run", title: "Running", color: .red)
                    .rotationEffect(.degrees(-1))
            }
            Text("No recorded activities")
                .font(.title)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
        }
    }
}

#Preview {
    NoActivityPlaceholder()
        .padding()
}


struct ActivityEmptyPlaceholder: View {
    let systemImage: String
    let title: String
    let color: Color
    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .padding()
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .padding(.bottom)
        }
        .frame(width: 120, height: 150)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(color)
                .shadow(radius: 2)
        }
        
    }
}
