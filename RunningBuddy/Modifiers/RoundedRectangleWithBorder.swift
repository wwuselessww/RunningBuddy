//
//  RoundedRectangleWithBorder.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 23.03.26.
//

import Foundation
import SwiftUI

struct RoundedRectangleWithBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                    
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 3)
                        .foregroundStyle(.black)
                }
                .foregroundStyle(.white)
                .opacity(0.5)
            }
    }
    
    
}


extension View {
    func roundedRectangleWithBorder() -> some View {
        self.modifier(WhiteRoundedText())
    }
}

