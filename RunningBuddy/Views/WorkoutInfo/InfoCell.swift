//
//  InfoCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 10.05.25.
//

import SwiftUI

struct InfoCell: View {
    
    init(title: LocalizedStringKey, data: String, units: LocalizedStringKey? = nil, dataColor: Color = .black) {
        self.title = title
        self.data = data
        self.color = dataColor
        self.units = units
    }
    var color: Color = .black
    var title: LocalizedStringKey
    var units: LocalizedStringKey?
    var data: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(.label)
            HStack {
                Text(data)
                if let unit = units {
                    Text(unit)
                }
                
            }
            .font(.callout.bold())
            .foregroundStyle(.label)
        }
    }
}

#Preview {
    InfoCell(title: "Avg Hearth Rate", data: "00;00;00", units: "km", dataColor: .red)
}
