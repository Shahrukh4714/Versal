import Foundation

protocol PurchaseServiceProtocol {
    var currentTier: SubscriptionTier { get }
    var monthlyPrice: String { get }
    var lifetimePrice: String { get }
    func loadProducts() async
    func purchaseMonthly() async throws
    func purchaseLifetime() async throws
    func restorePurchases() async throws
    func canPerformProAction() -> Bool
}
