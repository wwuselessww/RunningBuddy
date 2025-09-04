//
//  OnbnoardingViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 01.09.25.
//

import SwiftUI

@Observable class OnbnoardingViewModel {
    var animationToggle: Bool = true
    var rotationAngle: Double = 0
    var locationGranted: Bool = false
    var healthKitGranted: Bool = false
}
