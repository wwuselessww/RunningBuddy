//
//  InfoCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 10.05.25.
//

import SwiftUI

struct InfoCell: View {
    var title: String
    var data: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .foregroundStyle(.gray)
            Text(data)
                .bold()
        }
    }
}

#Preview {
    InfoCell(title: "Avg Hearth Rate", data: "00;00;00")
}
