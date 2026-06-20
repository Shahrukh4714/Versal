import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isFaceIDEnabled: Bool = false
    @Published var isPasswordProtectEnabled: Bool = false
    @Published var isICloudSyncEnabled: Bool = true
    @Published var subscriptionTier: SubscriptionTier = .free
    @Published var defaultExportFormat: String = "PDF"
    @Published var errorMessage: String?

    @AppStorage("darkModeOption") var darkModeStorage: String = DarkModeOption.system.rawValue

    enum DarkModeOption: String, CaseIterable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"
    }

    var darkModeOption: DarkModeOption {
        get { DarkModeOption(rawValue: darkModeStorage) ?? .system }
        set { darkModeStorage = newValue.rawValue }
    }

    var resolvedColorScheme: ColorScheme? {
        switch darkModeOption {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
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
            do {
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
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func restorePurchase() {
        Task {
            do {
                try await purchaseService.restorePurchases()
                subscriptionTier = purchaseService.currentTier
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
