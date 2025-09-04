//
//  Hello.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 01.09.25.
//

import SwiftUI

struct Hello: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Hello")
                .foregroundStyle(.label)
                .whiteRoundedText()
                .font(.system(size: 50))
                .rotationEffect(Angle(degrees: 5))
                .padding(.bottom, 40)
            Text("YOU will learn HOW to start running with EASE")
                .foregroundStyle(.label)
                .multilineTextAlignment(.center)
                .font(.system(size: 25))
                .whiteRoundedText()
            Spacer()
        }
//        .meshBackground(isAnimating: .constant(true), color1: .purple, color2: .blue, color3: .mint)
        
    }
}

#Preview {
    Hello()
}
