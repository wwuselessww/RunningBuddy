//
//  NoActivityPlaceholder.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 17.02.26.
//

import SwiftUI

struct NoActivityPlaceholder: View {
    var body: some View {
        ZStack {
            Image(systemName: "figure.outdoor.cycle")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 120, height: 150)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .glassEffect(in: .rect(cornerRadius: 20))
                }
            
                
                
                
                
        }
    }
}

#Preview {
    NoActivityPlaceholder()
        .padding()
}
