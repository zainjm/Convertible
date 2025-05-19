//
//  MainScreenView.swift
//  ImageConverterApp
//
//  Created by Zain Najam Khan on 18/05/2025.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct MainScreenView: View {
    @StateObject private var viewModel = ImageConverterViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#f0dfe6")
                    .ignoresSafeArea()
                VStack(spacing: 24) {
                    Text("Convert Your Image")
                        .font(.title.bold())
                        .foregroundColor(Color(hex: "#913d63"))
                        .padding(.top, 48)
                    PhotosPicker(
                        "Select Images",
                        selection: $viewModel.selectedItems,
                        maxSelectionCount: 10,
                        matching: .images
                    )
                    .foregroundColor(Color(hex: "#913d63"))
                    .onChange(of: viewModel.selectedItems) { _ in
                        Task {
                            await viewModel.loadSelectedImages()
                        }
                    }
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                            ForEach(viewModel.selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                            }
                        }
                    }
                    .frame(height: 240)
                    .padding(.horizontal)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#913d63"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    
                    Picker("Format", selection: $viewModel.selectedFormat) {
                        ForEach(ImageFormat.allCases) { format in
                            Text(format.rawValue).tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    Button("Convert & Share") {
                        viewModel.convertAllImages()
                        viewModel.shareConvertedImages()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .padding(0.0)
                    .background($viewModel.selectedImages.isEmpty ? Color.gray.opacity(0.4) : Color(hex: "#913d63"))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .disabled($viewModel.selectedImages.isEmpty)
                    Spacer()
                }
                .padding()
            }
        } .tint(Color(hex: "#913d43"))
        
    }
}

#Preview {
    MainScreenView()
        .modelContainer(for: Item.self, inMemory: true)
}
