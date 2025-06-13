//
//  TrainingDetail.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.05.25.
//

import SwiftUI

struct TrainingDetail: View {
    var title: String
    @Binding var metric: String
    var unitOfMeasurement: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 24))
                .foregroundStyle(.blue)
//            Text("\(String(format: "%0.1f", metric)) \(unitOfMeasurement)")
            Text("\(metric) \(unitOfMeasurement)")
                .contentTransition(.numericText())
                .font(.system(size: 36))
        }
        .fontWeight(.semibold)
    }
}

#Preview {
    TrainingDetail(title: "Speed", metric: .constant("sl"), unitOfMeasurement: "km/h")
}

