//
//  SettingsView.swift
//  Convertible
//
//  Created by Zain Najam Khan on 19/05/2025.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#f0dfe6").ignoresSafeArea()
                Form {
                    Section(header: Text("General")) {
                        Toggle("Dark Mode", isOn: .constant(false))
                    }

                    Section {
                        Text("Version 1.0.0")
                            .foregroundColor(.gray)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Item.self, inMemory: true)
}
