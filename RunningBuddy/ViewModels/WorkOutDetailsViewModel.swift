//
//  WorkOutDetailsViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.05.25.
//

import SwiftUI

class WorkOutDetailsViewModel: ObservableObject {
    @Published var viewFrames: [CGRect] = [.zero, .zero, .zero]
    var pointArray: [CGPoint] {
        var temp: [CGPoint] = []
        for frame in viewFrames {
            temp.append(CGPoint(x: frame.midX, y: frame.midY))
        }
        return temp
    }
    
}
