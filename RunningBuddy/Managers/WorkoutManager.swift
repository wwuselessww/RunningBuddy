//
//  WorkoutManager.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 17.06.25.
//

import Foundation
import CoreLocation

class WorkoutManager: ObservableObject {
    var locationArray: [CLLocation] = []
    @Published var distance: CLLocationDistance = 0
    func recordLocation(_ location: CLLocation) {
        locationArray.append(location)
    }
    
    func getTottalDistance() {
        guard locationArray.count > 1 else { return }
        var temp: CLLocationDistance = 0
        for i in 1..<locationArray.count {
            
            let segmentDistance = locationArray[i - 1].distance(from: locationArray[i])
            print("distance \(segmentDistance / 1000)")
            temp += segmentDistance
        }
        distance = temp
    }
}
