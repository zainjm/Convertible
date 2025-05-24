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
    @StateObject private var iapManager = IAPManager.shared
    @State private var showResults = false
    @State private var isLoading = false
    @State private var showPaywall = false
    @State private var paywallMessage: String? = nil
    let freeLimit = 3
    
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
                            ForEach(viewModel.displayableImages) { displayable in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: displayable.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(Theme.cornerRadius)
                                        .shadow(color: Theme.shadow, radius: Theme.shadowRadius)
                                        .transition(.scale.combined(with: .opacity))
                                    Button(action: {
                                        withAnimation {
                                            if let idx = viewModel.displayableImages.firstIndex(where: { $0.id == displayable.id }) {
                                                viewModel.displayableImages.remove(at: idx)
                                            }
                                            if let imgIdx = viewModel.selectedImages.firstIndex(where: { $0.pngData() == displayable.image.pngData() }) {
                                                viewModel.selectedImages.remove(at: imgIdx)
                                                viewModel.selectedItems.remove(at: imgIdx)
                                            }
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .background(Circle().fill(Color.black.opacity(0.6)))
                                    }
                                    .offset(x: 4, y: -4)
                                }
                            }
                        }
                        .animation(.default, value: viewModel.displayableImages)
                    }
                    .frame(height: 240)
                    .padding(.horizontal)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Theme.cardColor)
                    .foregroundColor(Theme.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    .padding(.horizontal)
                    
                    Picker("Format", selection: $viewModel.selectedFormat) {
                        ForEach(ImageFormat.allCases) { format in
                            Text(format.rawValue).tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    if viewModel.selectedFormat == .jpeg || viewModel.selectedFormat == .heic {
                        VStack(alignment: .leading) {
                            Text("Compression Quality: \(Int(viewModel.compressionQuality * 100))%")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#913d63"))
                            Slider(value: $viewModel.compressionQuality, in: 0.1...1.0, step: 0.05)
                                .accentColor(Color(hex: "#913d63"))
                        }
                        .padding(.horizontal)
                    }
                    Button("Convert") {
                        if !iapManager.hasPro && viewModel.selectedImages.count > freeLimit {
                            withAnimation {
                                paywallMessage = "Upgrade to Pro to convert more than 3 images at once."
                                showPaywall = true
                            }
                        } else {
                            isLoading = true
                            Task {
                                await viewModel.convertAllImages()
                                isLoading = false
                                showResults = true
                            }
                        }
                    }
                    .disabled(viewModel.selectedImages.isEmpty)
                    .opacity(isLoading ? 0.5 : 1)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .padding(0.0)
                    .background(viewModel.selectedImages.isEmpty ? Color.gray.opacity(0.4) : Color(hex: "#913d63"))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    Spacer()
                }.padding()
                if isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView("Converting...")
                        .padding()
                        .background(Color(hex: "f0dfe6"))
                        .cornerRadius(8)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#913d63"))
                }
                NavigationLink(
                    destination: ResultsScreenView(
                        convertedData: viewModel.convertedImageData,
                        format: viewModel.selectedFormat
                    ),
                    isActive: $showResults
                ) {
                    EmptyView()
                }
                .hidden()
                if showPaywall {
                    PaywallModalView(
                        isPresented: $showPaywall,
                        product: iapManager.product,
                        message: paywallMessage,
                        onBuy: { completion in
                            Task {
                                await iapManager.purchase()
                                completion(iapManager.hasPro)
                            }
                        },
                        onRestore: { Task { await iapManager.restore() } }
                    )
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(2)
                }
            }
        } .tint(Color(hex: "#913d43"))
    }
}

struct DisplayableImage: Identifiable, Equatable {
    let id = UUID()
    let image: UIImage
}

#Preview {
    MainScreenView()
        .modelContainer(for: Item.self, inMemory: true)
}
