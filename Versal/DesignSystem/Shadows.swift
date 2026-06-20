import SwiftUI

struct CardShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.05), radius: 0, x: 0, y: 1)
            .shadow(color: .black.opacity(0.04), radius: 0, x: 0, y: 0)
    }
}

extension View {
    func cardShadow() -> some View {
        modifier(CardShadow())
    }
}
