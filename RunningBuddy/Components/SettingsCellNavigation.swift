//
//  SettingsCell.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 30.03.26.
//

import SwiftUI



struct SettingsCell<Destination: View, MenuContent: View, MenuLabel: View>: View {
    var image: Image = Image(systemName: "gear")
    var title: LocalizedStringKey
    var color: Color
    var data: LocalizedStringKey?
    var destination: Destination?
    var menuContent: MenuContent?
    var menuLabel: MenuLabel?

    init(
        image: Image = Image(systemName: "gear"),
        title: LocalizedStringKey,
        color: Color = .primary,
        data: LocalizedStringKey? = nil,
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder menuContent: () -> MenuContent,
        @ViewBuilder menuLabel: () -> MenuLabel
    ) {
        self.image = image
        self.title = title
        self.color = color
        self.destination = destination()
        self.menuContent = menuContent()
        self.menuLabel = menuLabel()
        self.data = data
    }

    var body: some View {
        if let destination {
            NavigationLink { destination } label: { label }
        } else if let menuContent, let menuLabel {
            label.overlay(alignment: .trailing) {
                Menu { menuContent } label: {
                    menuLabel
                }
                .padding(.trailing)
            }
        } else {
            label
        }
    }

    private var label: some View {
        HStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .foregroundStyle(color)
            Text(title)
                .font(.callout)
            if let data {
                Text(data)
                    .font(.callout)
            }
                
            Spacer()
        }
    }
}

#Preview {
    let img = Image(systemName: "gear")
    List {
        SettingsCell(image: img, title: "settingss", destination: {
            SettingsPage()
        })
        
    }
   
}

// No destination, no menu — plain cell
extension SettingsCell where Destination == EmptyView, MenuContent == EmptyView, MenuLabel == EmptyView {
    init(
        image: Image = Image(systemName: "gear"),
        title: LocalizedStringKey,
        color: Color = .primary
    ) {
        self.image = image
        self.title = title
        self.color = color
        self.destination = nil
        self.menuContent = nil
    }
}

// NavigationLink only
extension SettingsCell where MenuContent == EmptyView, MenuLabel == EmptyView {
    init(
        image: Image = Image(systemName: "gear"),
        title: LocalizedStringKey,
        color: Color = .primary,
        data: LocalizedStringKey? = nil,
        @ViewBuilder destination: () -> Destination
    ) {
        self.image = image
        self.title = title
        self.color = color
        self.destination = destination()
        self.menuContent = nil
        self.data = data
    }
}

// Menu only
extension SettingsCell where Destination == EmptyView {
    init(
        image: Image = Image(systemName: "gear"),
        title: LocalizedStringKey,
        color: Color = .primary,
        @ViewBuilder menuContent: () -> MenuContent,
        @ViewBuilder menuLabel: () -> MenuLabel
    ) {
        self.image = image
        self.title = title
        self.color = color
        self.menuLabel = nil
        self.menuContent = menuContent()
    }
}


