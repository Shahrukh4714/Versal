import Foundation

enum HapticFeedbackType {
    case success
    case destructive
    case sheetOpen
    case sheetClose
    case press
    case error
}

protocol HapticServiceProtocol {
    func trigger(_ type: HapticFeedbackType)
}
