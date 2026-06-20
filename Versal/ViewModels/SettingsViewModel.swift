import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isFaceIDEnabled: Bool = false
    @Published var isPasswordProtectEnabled: Bool = false
    @Published var darkModeOption: DarkModeOption = .system
    @Published var isICloudSyncEnabled: Bool = true
    @Published var subscriptionTier: SubscriptionTier = .free
    @Published var defaultExportFormat: String = "PDF"

    enum DarkModeOption: String, CaseIterable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"
    }

    private let authService: AuthServiceProtocol
    private let purchaseService: PurchaseServiceProtocol

    init(
        authService: AuthServiceProtocol = AuthService(),
        purchaseService: PurchaseServiceProtocol = PurchaseService()
    ) {
        self.authService = authService
        self.purchaseService = purchaseService
        self.subscriptionTier = purchaseService.currentTier
    }

    func toggleFaceID() {
        Task {
            if !isFaceIDEnabled {
                let success = try await authService.authenticateWithFaceID(reason: "Enable Face ID lock")
                if success {
                    authService.isFaceIDEnabled = true
                    isFaceIDEnabled = true
                }
            } else {
                authService.isFaceIDEnabled = false
                isFaceIDEnabled = false
            }
        }
    }

    func restorePurchase() {
        Task {
            try await purchaseService.restorePurchases()
            subscriptionTier = purchaseService.currentTier
        }
    }
}
