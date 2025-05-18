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
    
    var id: String { rawValue }
    
    var fileExtension: String {
        switch self {
        case .jpeg: return "jpg"
        case .png: return "png"
        }
    }
}
