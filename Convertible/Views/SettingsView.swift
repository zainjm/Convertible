//
//  SettingsView.swift
//  Convertible
//
//  Created by Zain Najam Khan on 19/05/2025.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @StateObject private var iapManager = IAPManager.shared
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#f0dfe6").ignoresSafeArea()
                Form {
                    Section(header: Text("General")) {
                        Toggle("Dark Mode", isOn: .constant(false))
                    }
                    Section(header: Text("In-App Purchases")) {
                        Button("Restore Purchases") {
                            Task {
                                await iapManager.restore()
                            }
                        }
                        // Optional: Sign in with Apple for cross-device sync
                        Button("Sign in with Apple (coming soon)") {
                            // Integrate ASAuthorizationAppleIDButton here
                        }
                        .disabled(true)
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
