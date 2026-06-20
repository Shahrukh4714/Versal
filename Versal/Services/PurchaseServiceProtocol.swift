import Foundation

protocol PurchaseServiceProtocol {
    var currentTier: SubscriptionTier { get }
    func purchaseMonthly() async throws
    func purchaseLifetime() async throws
    func restorePurchases() async throws
    func canPerformProAction() -> Bool
}
