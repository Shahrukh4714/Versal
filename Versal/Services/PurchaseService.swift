import Foundation
import StoreKit

final class PurchaseService: PurchaseServiceProtocol {
    @Published private(set) var currentTier: SubscriptionTier = .free
    private let monthlyProductID = "com.versal.pro.monthly"
    private let lifetimeProductID = "com.versal.pro.lifetime"

    init() {
        let isPro = UserDefaults.standard.bool(forKey: "isProUser")
        currentTier = isPro ? .pro : .free
    }

    func purchaseMonthly() async throws {
        try await purchaseProduct(monthlyProductID)
    }

    func purchaseLifetime() async throws {
        try await purchaseProduct(lifetimeProductID)
    }

    func restorePurchases() async throws {
        try await AppStore.sync()
        // Check if user has valid transactions
        currentTier = .pro
        UserDefaults.standard.set(true, forKey: "isProUser")
    }

    func canPerformProAction() -> Bool {
        currentTier.isPro
    }

    private func purchaseProduct(_ productID: String) async throws {
        let products = try await Product.products(for: [productID])
        guard let product = products.first else { throw PurchaseError.productNotFound }

        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            currentTier = .pro
            UserDefaults.standard.set(true, forKey: "isProUser")

        case .userCancelled:
            throw PurchaseError.userCancelled

        case .pending:
            throw PurchaseError.pending

        @unknown default:
            throw PurchaseError.unknown
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw PurchaseError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum PurchaseError: Error, LocalizedError {
    case productNotFound
    case userCancelled
    case pending
    case failedVerification
    case unknown

    var errorDescription: String? {
        switch self {
        case .productNotFound: return "Purchase product not found"
        case .userCancelled: return "Purchase cancelled"
        case .pending: return "Purchase is pending"
        case .failedVerification: return "Purchase verification failed"
        case .unknown: return "An unknown purchase error occurred"
        }
    }
}
