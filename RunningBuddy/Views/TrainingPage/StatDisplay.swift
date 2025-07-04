//
//  StatDisplay.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 03.07.25.
//

import SwiftUI

struct StatDisplay: View {
    var title: String
    var value: String
    var unit: String
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.all)
                Spacer()
            }
            Text(value)
                .font(Font.system(size: 44, weight: .bold, design: .default))
//                .font(.la)
                .fontWeight(.bold)
                .contentTransition(.numericText())
            HStack {
                Spacer()
                Text(unit)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.all)
                    
            }
        }
        .background {
            Rectangle()
                .stroke(lineWidth: 0.5)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    StatDisplay(title: "Time remaining", value: "00:00", unit: "min")
        .padding(.all)
}
