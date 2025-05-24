import Foundation
import StoreKit

protocol ProductProtocol {
    var id: String { get }
    var displayName: String { get }
    var displayPrice: String { get }
}

struct ProductStub: ProductProtocol {
    let id: String
    let displayName: String
    let displayPrice: String
}

extension Product: ProductProtocol {
    var id: String { self.id }
    var displayName: String { self.displayName }
    var displayPrice: String { self.displayPrice }
} 
