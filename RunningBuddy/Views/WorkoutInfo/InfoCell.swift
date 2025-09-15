//
//  InfoCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 10.05.25.
//

import SwiftUI

struct InfoCell: View {
    
    init(title: String, data: String, dataColor: Color = .black) {
        self.title = title
        self.data = data
        self.color = dataColor
    }
    var color: Color = .black
    var title: String
    var data: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .foregroundStyle(.gray)
            Text(data)
                .bold()
                .foregroundStyle(color)
        }
    }
}

#Preview {
    InfoCell(title: "Avg Hearth Rate", data: "00;00;00", dataColor: .red)
}
