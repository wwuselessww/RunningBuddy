//
//  Header.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI

struct Header: View {
    @Binding var distance: Int
    var body: some View {
        VStack {
            Text("You have already run")
            HStack {
                Text("\(distance)km")
                    .foregroundStyle(.white)
                    .padding(.all, 5)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.red)
                    }
                    .foregroundStyle(.white)
                Text(" this month")
            }
        }
        .font(Font.system(size: 30))
        .fontDesign(.rounded)
        .fontWeight(.semibold)
    }
}

#Preview {
    Header(distance: .constant(0))
    Spacer()
}

