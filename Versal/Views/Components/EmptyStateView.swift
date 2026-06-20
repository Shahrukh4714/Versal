import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let actionTitle: String?
    let action: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "doc.viewfinder")
                .font(.system(size: 48))
                .foregroundColor(.inkBlue.opacity(0.3))

            Text(title)
                .sectionHeaderStyle()
                .foregroundColor(.labelPrimary)

            Text(subtitle)
                .bodyStyle()
                .foregroundColor(.labelSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .bodyBoldStyle()
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(Color.inkBlue)
                        .cornerRadius(CornerRadius.button)
                }
            }

            HStack(spacing: 4) {
                LogomarkInline()
                Text("Everything stays on your device")
                    .captionStyle()
                    .foregroundColor(.labelTertiary)
            }
            .padding(.top, 8)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
