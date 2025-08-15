//
//  ChartModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 19.07.25.
//

import Foundation
import Charts

//struct ChartModel: Identifiable, Equatable {
//    var index: Int
//    var number: Int
//    var id = UUID()
//    var isAnimated: Bool = false
//    
//}

struct ChartModel: Identifiable, Equatable {
    var date: Date
    var number: Int
    var id = UUID()
    var isAnimated: Bool = false
    
}
