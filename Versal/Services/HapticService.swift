import UIKit

final class HapticService: HapticServiceProtocol {
    func trigger(_ type: HapticFeedbackType) {
        switch type {
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .destructive:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .sheetOpen:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .sheetClose:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .press:
            UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.7)
        }
    }
}
