import Foundation
import StoreKit

@MainActor
final class IAPManager: ObservableObject {
    static let shared = IAPManager()
    @Published var hasPro: Bool = UserDefaults.standard.bool(forKey: "hasPro")
    @Published var product: ProductProtocol?
    @Published var isTestMode: Bool = false
    let proProductID = "com.yourcompany.imageconverter.pro"
    var testModeEnabled = false

    private init() {}

    func enableTestMode() {
        isTestMode = true
        testModeEnabled = true
        // Simulate product
        self.product = ProductStub(id: proProductID, displayName: "Pro Unlock", displayPrice: "$8.99")
    }

    func fetchProduct() async {
        if testModeEnabled {
            // Already stubbed
            return
        }
        do {
            let products = try await Product.products(for: [proProductID])
            self.product = products.first
        } catch {
            print("Failed to fetch product: \(error)")
        }
    }

    func purchase() async {
        if testModeEnabled {
            UserDefaults.standard.set(true, forKey: "hasPro")
            hasPro = true
            return
        }
        guard let product = product as? Product else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(.verified(_)):
                UserDefaults.standard.set(true, forKey: "hasPro")
                hasPro = true
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    func restore() async {
        if testModeEnabled {
            hasPro = true
            UserDefaults.standard.set(true, forKey: "hasPro")
            return
        }
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.productID == proProductID, transaction.revocationDate == nil {
                    UserDefaults.standard.set(true, forKey: "hasPro")
                    hasPro = true
                }
            default:
                break
            }
        }
    }
}
