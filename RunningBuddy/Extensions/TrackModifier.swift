//
//  TrackModifier.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.05.25.
//

import SwiftUI

struct TrackModifier: ViewModifier {
    var index: Int
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: UpdateArray.self, value: [ViewFramesPreferences(index: index, frame: geo.frame(in: .named("WorkoutDetailsSpace")))])
                  }
                }
            }
    }


extension View {
    func track(index: Int) -> some View {
        modifier(TrackModifier(index: index))
    }
}

struct UpdateArray: PreferenceKey {
    static var defaultValue: [ViewFramesPreferences] = []
    
    static func reduce(value: inout [ViewFramesPreferences], nextValue: () -> [ViewFramesPreferences]) {
        value.append(contentsOf: nextValue())
    }
    
    typealias Value = [ViewFramesPreferences]
    
    
}

struct ViewFramesPreferences: Equatable {
    let index: Int
    let frame: CGRect
}
