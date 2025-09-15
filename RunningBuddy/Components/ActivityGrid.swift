//
//  ActivityGrid.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 12.08.25.
//

import SwiftUI

struct ActivityGrid: View {
    var data: [ActivityForGrid]
    let color: Color
//    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let columns = Array(repeating: GridItem(.adaptive(minimum: 30)), count: 7)
    
    let cellSize: CGFloat = 30
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(data, id: \.id) { cell in
                RoundedRectangle(cornerRadius: 10)
                    .fill(cell.isRecorded ? color : color.opacity(0.4))
                    .frame(minHeight: 30)
                
            }
        }
    }
}

#Preview {
    var data: [ActivityForGrid] {
        var array: [ActivityForGrid] = []
        for _ in 0..<31 {
            array.append(.init(isRecorded: Bool.random(), number: 1))
        }
        return array
    }
    
    VStack {
        
        ActivityGrid(data: data, color: .red)
            .frame(height: 200)
        Spacer()
    }
    
}



