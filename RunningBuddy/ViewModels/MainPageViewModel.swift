//
//  MainPageViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI

class MainPageViewModel: ObservableObject {
    @Published var totalMonthDistance: Int = 10
    @Published var maxActivity: Int = 1000
    @Published var currentActivity: Int = 200
}
