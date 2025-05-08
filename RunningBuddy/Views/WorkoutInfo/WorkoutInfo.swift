//
//  WorkoutInfo.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.05.25.
//

import SwiftUI
import MapKit

struct WorkoutInfo: View {
    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack (alignment: .leading) {
                    Map()
                        .frame(height: geo.size.height/2)
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Ourdoor Run")
                        .fontWeight(.semibold)
                        .font(.system(size: 34))
                        .padding()
                    Spacer()
                }
                Spacer()
                Text("sas")
                WeatherConditions(temperature: 12, windSpeed: 134, humidity: 100)
                Spacer()
            }
            
        }
    }
}
#Preview {
    WorkoutInfo()
}
