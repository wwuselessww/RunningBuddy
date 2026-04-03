//
//  ProfilePage.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 28.01.26.
//

import SwiftUI

struct ProfilePage: View {
    private let flameSize: CGFloat = 80
    @State var currentStreak: Int = 0
    @State var days: [Days] = [.init(name: "mon", number: 1, isSelected: true),.init(name: "tue", number: 2),.init(name: "wen", number: 3),.init(name: "thu", number: 4),.init(name: "fri", number: 5),.init(name: "sat", number: 6),.init(name: "sun", number: 7)]
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 1) {
                    HStack {
                        Text("26")
                            .font(.system(size: 100))
                            .fontDesign(.rounded)
                            .bold()
                        Image(systemName: "flame")
                            .resizable()
                            .scaledToFit()
                            .frame(width: flameSize, height: flameSize)
                            .foregroundStyle(.orange)
                    }

                    Text("Current streak")
                        .font(.title2)
                        .fontDesign(.rounded)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .glassEffect()
                }
                
                List {
                    Section("Pick your workout days") {
                        
                        HStack(spacing: 10) {
                            Spacer()
                            ForEach(days.indices, id: \.self) { index in
                                Button(action: {
                                    days[index].isSelected.toggle()
                                    print(index)
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(lineWidth: 3)
                                            .foregroundStyle(.label)
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle( days[index].isSelected ? .green : .gray)
                                            .opacity(0.2)
                                        Text(days[index].name.capitalized)
                                            .foregroundStyle(.label)
                                    }
                                })
                                    .frame(width: 40, height: 50)
                                    .buttonStyle(.plain)
                                    
                            }
                            Spacer()
                        }
                    }
                    Section("Settings") {
                        SettingsCell(image: Image(systemName: "bell"), title: "Notifications", color: .green, destination: {MainPage()})
                        SettingsCell(image: Image(systemName: "calendar"), title: "Streak calendar", color: .black, destination: {MainPage()})
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                
                Spacer()
                
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfilePage()
    }
}


