import Foundation

enum HapticFeedbackType {
    case success
    case destructive
    case sheetOpen
    case sheetClose
    case press
}

protocol HapticServiceProtocol {
    func trigger(_ type: HapticFeedbackType)
}
