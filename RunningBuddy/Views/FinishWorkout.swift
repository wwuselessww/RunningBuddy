//
//  FinishWorkout.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 18.06.25.
//

import SwiftUI
import MapKit

struct FinishWorkout: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Map{
                
            }
            .ignoresSafeArea(.all)
            VStack {
                Spacer()
                VStack {
                    
                    Text("Saturday 3 may 2025")
                    HStack {
                        InfoCell(title: "Time", data: "00:00:00")
                        Spacer()
                        InfoCell(title: "Distance", data: "10 km")
                        Spacer()
                        InfoCell(title: "Speed", data: "10km/h")
                        
                    }
                }
                .padding(.horizontal)
                .background {
                    LinearGradient(colors: [.white, .white.opacity(0.8)], startPoint: .bottom, endPoint: .top)
                        .blur(radius: 10)
                        .ignoresSafeArea(edges: .bottom)
                }
            }
            
        }
    }
}

#Preview {
    FinishWorkout()
}
