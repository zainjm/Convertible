//
//  ResultsScreenView.swift
//  Convertible
//
//  Created by Zain Najam Khan on 20/05/2025.
//

import Foundation
import SwiftUI

struct ResultsScreenView: View {
    let convertedData: [Data]
    let format: ImageFormat

    @State private var selectedIndices: Set<Int> = []
    @State private var selectAll = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Conversion Complete!")
                    .font(.largeTitle.bold())
                    .foregroundColor(Theme.accentColor)
                    .padding(.top)
                Text("Preview and share your converted images.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                if !convertedData.isEmpty {
                    HStack(spacing: 12) {
                        Button(action: shareAllImages) {
                            Label("Share All", systemImage: "square.and.arrow.up")
                                .font(.headline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Theme.accentColor)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                        Button(action: toggleSelectAll) {
                            Text(selectAll ? "Deselect All" : "Select All")
                                .font(.headline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Theme.cardColor)
                                .foregroundColor(Theme.accentColor)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(Theme.accentColor, lineWidth: 2)
                                )
                        }
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(Array(convertedData.enumerated()), id: \.offset) { index, data in
                            if let image = UIImage(data: data) {
                                ZStack(alignment: .topTrailing) {
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            toggleSelection(index)
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        }
                                    }) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 220, height: 220)
                                            .clipped()
                                            .background(Theme.cardColor)
                                            .cornerRadius(Theme.cornerRadius)
                                            .shadow(color: Theme.shadow, radius: Theme.shadowRadius)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                                    .stroke(selectedIndices.contains(index) ? Theme.accentColor : Color.clear, lineWidth: 4)
                                            )
                                            .scaleEffect(selectedIndices.contains(index) ? 1.04 : 1.0)
                                            .animation(.spring(), value: selectedIndices)
                                    }
                                    Image(systemName: selectedIndices.contains(index) ? "checkmark.circle.fill" : "circle")
                                        .resizable()
                                        .frame(width: 26, height: 26)
                                        .foregroundColor(selectedIndices.contains(index) ? Theme.accentColor : .white)
                                        .padding(8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 260)
                HStack(spacing: 12) {
                    Button("Share Selected (\(selectedIndices.count))") {
                        shareSelectedImages()
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                    .disabled(selectedIndices.isEmpty)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedIndices.isEmpty ? Color.gray.opacity(0.4) : Theme.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    Button("Convert More") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.cardColor)
                    .foregroundColor(Theme.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .stroke(Theme.accentColor, lineWidth: 2)
                    )
                }
                .padding(.horizontal)
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .background(Theme.backgroundColor.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Toggle card selection
    private func toggleSelection(_ index: Int) {
        if selectedIndices.contains(index) {
            selectedIndices.remove(index)
        } else {
            selectedIndices.insert(index)
        }
        updateSelectAllState()
    }

    // Select or deselect all
    private func toggleSelectAll() {
        if selectAll {
            selectedIndices.removeAll()
        } else {
            selectedIndices = Set(convertedData.indices)
        }
        selectAll.toggle()
    }

    // Track select-all status
    private func updateSelectAllState() {
        selectAll = selectedIndices.count == convertedData.count
    }

    // Share logic
    private func shareSelectedImages() {
        let selectedData = selectedIndices.compactMap { convertedData[$0] }
        let urls: [URL] = selectedData.enumerated().compactMap { index, data in
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("converted_\(index).\(format.fileExtension)")
            try? data.write(to: url)
            return url
        }
        let activityVC = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(activityVC, animated: true)
        }
    }

    private func shareAllImages() {
        let urls: [URL] = convertedData.enumerated().compactMap { index, data in
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("converted_\(index).\(format.fileExtension)")
            try? data.write(to: url)
            return url
        }
        let activityVC = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(activityVC, animated: true)
        }
    }
}

#Preview {
    let sampleImage = UIImage(systemName: "photo")!
    let sampleData = sampleImage.jpegData(compressionQuality: 1.0) ?? Data()
    let sampleList = Array(repeating: sampleData, count: 5)
    
    return ResultsScreenView(
        convertedData: sampleList,
        format: .jpeg
    )
}
