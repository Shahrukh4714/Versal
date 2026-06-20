import SwiftUI

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.cardInternal)
            .background(Color.surfaceCard)
            .cornerRadius(CornerRadius.card)
            .cardShadow()
    }
}
