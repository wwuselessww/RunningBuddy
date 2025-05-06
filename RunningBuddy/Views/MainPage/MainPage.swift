//
//  MainView.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 25.04.25.
//

import SwiftUI

struct MainPage: View {
    @ObservedObject var vm = MainPageViewModel()
    var body: some View {
        VStack {
            Header(distance: $vm.totalMonthDistance)
            Spacer()
        }
    }
}
#Preview {
    MainPage()
}


