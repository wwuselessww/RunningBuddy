//
//  WhiteRoundedText.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 01.09.25.
//

import Foundation
import SwiftUI

struct WhiteRoundedText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontDesign(.rounded)
            .fontWeight(.bold)
            .foregroundStyle(.white)
    }
}

extension View {
    func whiteRoundedText() -> some View {
        self.modifier(WhiteRoundedText())
    }
}
