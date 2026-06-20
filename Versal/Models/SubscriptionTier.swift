import Foundation

enum SubscriptionTier: String, Codable {
    case free
    case pro

    var isPro: Bool { self == .pro }
}
