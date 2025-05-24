//
//  ImageConverterViewModel.swift
//  ImageConverterApp
//
//  Created by Zain Najam Khan on 18/05/2025.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class ImageConverterViewModel: ObservableObject {
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var selectedImages: [UIImage] = []
    @Published var selectedFormat: ImageFormat = .jpeg
    @Published var convertedImageData: [Data] = []
    @Published var compressionQuality: Double = 0.9
    @Published var displayableImages: [DisplayableImage] = []
    
    func loadSelectedImages() async {
        selectedImages = []
        displayableImages = []
        for item in selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImages.append(image)
                displayableImages.append(DisplayableImage(image: image))
            }
        }
    }

    func convertAllImages() {
        convertedImageData = selectedImages.compactMap { image in
            switch selectedFormat {
            case .jpeg:
                return image.jpegData(compressionQuality: compressionQuality)
            case .png:
                return image.pngData()
            case .tiff:
                return image.tiffRepresentation()
            case .heic:
                return image.heicData(quality: compressionQuality)
            case .pdf:
                return image.convertToPDF()
            }
        }
    }

    func shareConvertedImages() {
        let tempFiles: [URL] = convertedImageData.enumerated().compactMap { index, data in
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("converted_\(index).\(selectedFormat.fileExtension)")
            try? data.write(to: url)
            return url
        }

        let activityVC = UIActivityViewController(activityItems: tempFiles, applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(activityVC, animated: true)
        }
    }
}
