//
//  WeatherConditions.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.05.25.
//

import SwiftUI

struct WeatherConditions: View {
    var temperature: Int
    var windSpeed: Int
    var humidity: Int
    var body: some View {
        HStack(spacing: 4) {
            Group {
                Image(systemName: "cloud")
                Text("\(temperature)℃")
                    .padding(.trailing)
                Image(systemName: "wind")
                Text("\(windSpeed) km/h")
                    .padding(.trailing)
                Image(systemName: "humidity.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.blue, .gray)
                .padding(.trailing, 0)
                Text("\(humidity)%")
            }
            .foregroundStyle(.gray)
            .font(.system(size: 12, weight: .bold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 2)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
                .foregroundStyle(.gray)
        }
        .frame(minWidth: 100, maxWidth: 250, minHeight: 20, maxHeight: 25)
    }
}

#Preview {
    WeatherConditions(temperature: 12, windSpeed: 14, humidity: 77)
        
}
