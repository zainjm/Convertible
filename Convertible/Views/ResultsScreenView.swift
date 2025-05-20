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
    @State private var currentPage = 0

    var body: some View {
           NavigationStack {
               VStack(spacing: 16) {
                   Text("Your Converted Images")
                       .font(.title2.bold())
                       .foregroundColor(Color(hex: "#913d63"))
                       .padding(.horizontal)
                   
                   ScrollView(.horizontal, showsIndicators: false) {
                       HStack(spacing: 16) {
                           ForEach(Array(convertedData.enumerated()), id: \.offset) { index, data in
                               if let image = UIImage(data: data) {
                                   ZStack(alignment: .topTrailing) {
                                       Image(uiImage: image)
                                           .resizable()
                                           .scaledToFill()
                                           .frame(width: 220, height: 220)
                                           .clipped()
                                           .cornerRadius(16)
                                           .shadow(radius: 4)
                                       
                                       Button(action: {
                                           toggleSelection(index)
                                       }) {
                                           Image(systemName: selectedIndices.contains(index) ? "checkmark.circle.fill" : "circle")
                                               .resizable()
                                               .frame(width: 26, height: 26)
                                               .foregroundColor(selectedIndices.contains(index) ? .green : .white)
                                               .padding(8)
                                       }
                                   }
                               }
                           }
                       }
                       .padding(.horizontal, 16)
                   }
                   .frame(height: 240)

                   Button("Share Selected (\(selectedIndices.count))") {
                       shareSelectedImages()
                   }
                   .disabled(selectedIndices.isEmpty)
                   .frame(maxWidth: .infinity)
                   .padding()
                   .background(selectedIndices.isEmpty ? Color.gray.opacity(0.4) : Color(hex: "#913d63"))
                   .foregroundColor(.white)
                   .clipShape(RoundedRectangle(cornerRadius: 12))
                   .padding(.horizontal)

                   Spacer()
               }
               .navigationTitle("Results")
               .navigationBarTitleDisplayMode(.inline)
               .background(Color(hex: "#f0dfe6").ignoresSafeArea())
           }
       }

    private func toggleSelection(_ index: Int) {
        if selectedIndices.contains(index) {
            selectedIndices.remove(index)
        } else {
            selectedIndices.insert(index)
        }
    }

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
