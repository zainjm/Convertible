//
//  MainTabView.swift
//  Convertible
//
//  Created by Zain Najam Khan on 19/05/2025.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MainScreenView()
                .tabItem {
                    Label("Convert", systemImage: "arrow.left.arrow.right")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(Color(hex: "#913d63"))
    }
}
