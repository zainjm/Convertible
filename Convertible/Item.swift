//
//  Item.swift
//  ImageConverterApp
//
//  Created by Zain Najam Khan on 18/05/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
