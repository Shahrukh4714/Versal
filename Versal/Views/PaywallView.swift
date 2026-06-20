import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirmation = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var haptics = HapticService()

    private let purchaseService = PurchaseService()

    var body: some View {
        if showConfirmation {
            confirmationView
        } else {
            paywallContent
        }
    }

    private var paywallContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.labelQuaternary)
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)

                VStack(spacing: 16) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.inkBlue)

                    Text("Pay once.\nOwn it forever.")
                        .heroHeadlineStyle()
                        .foregroundColor(.labelPrimary)
                        .multilineTextAlignment(.center)

                    Text("No subscription. No recurring fees.")
                        .bodyStyle()
                        .foregroundColor(.labelSecondary)
                }

                VStack(spacing: 12) {
                    featureCard(icon: "magnifyingglass", title: "OCR Search", description: "Search text inside scanned documents", color: .inkBlue)
                    featureCard(icon: "eye.slash", title: "Redact", description: "Permanently hide sensitive content", color: .inkBlack)
                    featureCard(icon: "brain.head.profile", title: "AI Tools", description: "Chat, summarize, translate, transcribe", color: .aiGradientStart)
                }
                .padding(.horizontal, Spacing.screenHorizontal)

                HStack(spacing: 20) {
                    compactFeature("Sign", "signature")
                    compactFeature("Pages", "doc.on.doc")
                    compactFeature("47+ Formats", "arrow.triangle.2.circlepath")
                }

                HStack(spacing: 12) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.destructiveRed)
                    Text("Subscriptions repeat")
                        .captionStyle()
                        .foregroundColor(.labelSecondary)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.successGreen)
                    Text("Versal: pay once")
                        .captionStyle()
                        .foregroundColor(.successGreen)
                }
                .padding(.horizontal, Spacing.screenHorizontal)

                VStack(spacing: 8) {
                    Text("$49.99")
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(.labelPrimary)
                    Text("One-time purchase")
                        .captionStyle()
                        .foregroundColor(.labelSecondary)
                }

                VStack(spacing: 12) {
                    Button(action: { purchase() }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Unlock Pro — $49.99")
                            }
                        }
                        .bodyBoldStyle()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.inkBlue)
                        .cornerRadius(CornerRadius.button)
                    }
                    .disabled(isLoading)

                    Button(action: { Task { try? await purchaseService.restorePurchases() } }) {
                        Text("Restore Purchase")
                            .bodyStyle()
                            .foregroundColor(.inkBlue)
                    }

                Button(action: { haptics.trigger(.press); dismiss() }) {
                Text("Maybe Later")
                    .bodyStyle()
                    .foregroundColor(.labelSecondary)
                }
                }
                .padding(.horizontal, Spacing.screenHorizontal)

                HStack(spacing: 6) {
                    Image(systemName: "shield.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.inkBlue)
                    Text("Billed via App Store · No account required")
                        .captionStyle()
                        .foregroundColor(.labelTertiary)
                }
                .padding(.bottom, 20)
            }
        }
        .background(Color.backgroundGrouped)
    }

    private var confirmationView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundColor(.successGreen)
                .onAppear { haptics.trigger(.success) }

            Text("Welcome to Pro")
                .heroHeadlineStyle()
                .foregroundColor(.labelPrimary)

            VStack(spacing: 8) {
                confirmChip("OCR Search", "magnifyingglass")
                confirmChip("Redact", "eye.slash")
                confirmChip("AI Tools", "brain.head.profile")
                confirmChip("Unlimited Conversions", "arrow.triangle.2.circlepath")
                confirmChip("Password Protection", "lock")
            }

            Spacer()

            Button(action: { dismiss() }) {
                Text("Start Using Versal Pro")
                    .bodyBoldStyle()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.inkBlue)
                    .cornerRadius(CornerRadius.button)
            }
            .padding(.horizontal, Spacing.screenHorizontal)
            .padding(.bottom, 40)
        }
        .background(Color.backgroundGrouped)
    }

    private func purchase() {
        isLoading = true
        Task {
            do {
                try await purchaseService.purchaseLifetime()
                showConfirmation = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    private func featureCard(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .bodyBoldStyle()
                    .foregroundColor(.labelPrimary)
                Text(description)
                    .captionStyle()
                    .foregroundColor(.labelSecondary)
            }
            Spacer()
        }
        .padding(12)
        .background(Color.surfaceCard)
        .cornerRadius(CornerRadius.card)
        .cardShadow()
    }

    private func compactFeature(_ text: String, _ icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.inkBlue)
            Text(text)
                .microStyle()
                .foregroundColor(.labelPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.surfaceCard)
        .cornerRadius(CornerRadius.card)
        .cardShadow()
    }

    private func confirmChip(_ text: String, _ icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.successGreen)
            Text(text)
                .bodyStyle()
                .foregroundColor(.labelPrimary)
            Spacer()
            Image(systemName: "checkmark")
                .font(.system(size: 12))
                .foregroundColor(.successGreen)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.surfaceCard)
        .cornerRadius(CornerRadius.card)
        .cardShadow()
    }
}
