//
//  HomeScreenView.swift
//  ImageConverterApp
//
//  Created by Zain Najam Khan on 18/05/2025.
//

import Foundation
import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                VStack(spacing: 12) {
                    Image("Convertible")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .shadow(radius: 5)
                    
                    Text("Convertible")
                        .font(.largeTitle.bold())
                        .foregroundColor(.primary)
                }
                Text("Easily convert your images between formats like PNG, JPEG, WebP, and more. No ads. No clutter. Just conversion.")
                    .font(.body)
                    .foregroundColor(Color(hex: "#913d63"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                NavigationLink(destination: MainTabView()) {
                    Text("Get Started")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#913d63"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)

                Spacer(minLength: 60)
            }
            .padding()
            .background(Color(hex: "#f0dfe6"))
        }
    }
}
#Preview {
    HomeScreenView()
        .modelContainer(for: Item.self, inMemory: true)
}
