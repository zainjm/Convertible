//
//  ImageFormatModel.swift
//  ImageConverterApp
//
//  Created by Zain Najam Khan on 18/05/2025.
//

import Foundation
enum ImageFormat: String, CaseIterable, Identifiable {
    case jpeg = "JPEG"
    case png = "PNG"
    case tiff = "TIFF"
    case heic = "HEIC"
    case pdf = "PDF"

    var id: String { self.rawValue }

    var fileExtension: String {
        switch self {
        case .jpeg: return "jpg"
        case .png: return "png"
        case .tiff: return "tiff"
        case .heic: return "heic"
        case .pdf: return "pdf"
        }
    }
}
