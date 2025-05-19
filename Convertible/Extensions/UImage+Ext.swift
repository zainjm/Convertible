//
//  UImage+Ext.swift
//  Convertible
//
//  Created by Zain Najam Khan on 19/05/2025.
//

import Foundation
import SwiftUI
import AVFoundation
import ImageIO
import MobileCoreServices

extension UIImage {
    func heicData() -> Data? {
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, AVFileType.heic as CFString, 1, nil),
              let cgImage = self.cgImage else { return nil }

        CGImageDestinationAddImage(destination, cgImage, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return data as Data
    }

    func convertToPDF() -> Data? {
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: self.size))
        let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("pdf")
        do {
            try renderer.writePDF(to: tmpURL, withActions: { context in
                context.beginPage()
                self.draw(at: .zero)
            })
            return try Data(contentsOf: tmpURL)
        } catch {
            print("PDF rendering failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    func tiffRepresentation() -> Data? {
        guard let cgImage = self.cgImage else { return nil }

        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, kUTTypeTIFF, 1, nil) else {
            return nil
        }

        CGImageDestinationAddImage(destination, cgImage, nil)
        guard CGImageDestinationFinalize(destination) else {
            return nil
        }

        return data as Data
    }
}
