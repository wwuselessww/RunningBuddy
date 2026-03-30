//
//  SettingsCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.03.26.
//

import SwiftUI

struct SettingsCellNavigation<Destination: View>: View {
    var image: Image  = Image(systemName: "gear")
    var color: Color
    var title: String
    var destination: Destination
    
    init(image: Image, color: Color = .label, title: String, @ViewBuilder destination: () -> Destination) {
        self.image = image
        self.title = title
        self.destination = destination()
        self.color = color
    }
    
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(color)
                Text(title.capitalized)
                
                    .font(.callout)
                    
                Spacer()
                
            }
        }

    }
}
#Preview {
    let img = Image(systemName: "gear")
    List {
        SettingsCellNavigation(image: img, title: "settingss") {
            ProfilePage()
        }
        
    }
   
}
