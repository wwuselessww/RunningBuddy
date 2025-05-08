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
//        ZStack {
//            GeometryReader { geo in
//                VStack (alignment: .leading) {
//                    Map()
//                        .frame(height: geo.size.height/1.5)
//                }
//            }
//            VStack(alignment: .leading) {
//                HStack {
//                    Text("Ourdoor Run")
//                        .fontWeight(.semibold)
//                        .font(.system(size: 34))
//                        .padding()
//                    Spacer()
//                }
//                Spacer(minLength: 200)
//                VStack (alignment: .leading) {
//                    Text("Saturday")
//                    WeatherConditions(temperature: 12, windSpeed: 134, humidity: 100)
//                    Spacer()
//                }
//                .frame(maxWidth: .infinity)
//                .background(.thinMaterial)
//            }
//        }
        ZStack {
            GeometryReader { geo in
                VStack {
                    Map()
                        .frame(maxHeight: geo.size.height / 2)
                    VStack {
                        Text("s")
                        Spacer()
                    }
                    
                    .frame(maxWidth: .infinity)
                    .background {
                        LinearGradient(colors: [.white, .red.opacity(0.9)], startPoint: .bottom, endPoint: .top)
                            .blur(radius:30, opaque: false)
                    }
                    .padding(.top, -60)
                    .ignoresSafeArea()
                }
            }
        }
    }
}
#Preview {
    WorkoutInfo()
}
