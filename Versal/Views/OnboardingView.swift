import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    @State private var haptics = HapticService()

    var body: some View {
        ZStack {
            if currentPage == 0 {
                screen1
            } else {
                screen2
            }
        }
    }

    private var screen1: some View {
        ZStack {
            Color.darkSurface
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("PRIVACY FIRST")
                    .kickerStyle()
                    .foregroundColor(.inkBlue)

                Text("Your files never\nleave this device")
                    .heroHeadlineStyle()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("100% offline. No accounts. No tracking.\nEverything processes right here.")
                    .bodyStyle()
                    .foregroundColor(.labelSecondary)
                    .multilineTextAlignment(.center)

                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.inkBlue.opacity(0.3), lineWidth: 2)
                        .frame(width: 180, height: 240)

                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.inkBlue.opacity(0.15))
                        .frame(width: 140, height: 200)
                        .overlay(
                            VStack(spacing: 8) {
                                ForEach(0..<4) { _ in
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.inkWash.opacity(0.2))
                                        .frame(height: 20)
                                        .padding(.horizontal, 16)
                                }
                            }
                        )

                    Image(systemName: "antenna.radiowaves.left.and.right.slash")
                        .font(.system(size: IconSize.inline))
                        .foregroundColor(.successGreen)
                        .offset(x: 70, y: -100)

                    Text("100% OFFLINE")
                        .microStyle()
                        .foregroundColor(.successGreen)
                        .offset(x: -60, y: -110)
                }
                .padding(.vertical, 20)

                HStack(spacing: 24) {
                    statItem("0", "Sign-ups")
                    statItem("0", "Uploads")
                    statItem("0", "Trackers")
                }

                Spacer()

                Button(action: { haptics.trigger(.press); withAnimation { currentPage = 1 } }) {
                    Text("See what Versal can do")
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
        }
    }

    private var screen2: some View {
        ZStack {
            Color.backgroundGrouped
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("MEET VERSAL")
                    .kickerStyle()
                    .foregroundColor(.inkBlue)

                Text("Your pocket\ndocument office")
                    .heroHeadlineStyle()
                    .foregroundColor(.labelPrimary)
                    .multilineTextAlignment(.center)

                Text("Scan documents, convert between 90+ formats,\nedit PDFs, and more — all offline.")
                    .bodyStyle()
                    .foregroundColor(.labelSecondary)
                    .multilineTextAlignment(.center)

                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.surfaceCard)
                        .frame(width: 200, height: 300)
                        .cardShadow()
                        .overlay(
                            VStack(spacing: 6) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.inkBlue)
                                    .frame(width: 160, height: 80)

                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.inkWash)
                                    .frame(height: 20)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.inkWash)
                                    .frame(height: 20)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.inkWash)
                                    .frame(height: 20)
                            }
                            .padding()
                        )

                    VStack(spacing: 8) {
                        featureBadge("Scan", "doc.viewfinder", .inkBlue)
                        featureBadge("Convert", "arrow.triangle.2.circlepath", Color.successGreen)
                        featureBadge("Edit PDF", "doc.richtext", Color.destructiveRed)
                    }
                    .offset(x: 130)
                }
                .padding(.vertical, 20)

                Spacer()

                Button(action: { haptics.trigger(.success); hasSeenOnboarding = true }) {
                    Text("Get Started")
                        .bodyBoldStyle()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.inkBlue)
                        .cornerRadius(CornerRadius.button)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, 16)

                Button("Skip") {
                    hasSeenOnboarding = true
                }
                .bodyStyle()
                .foregroundColor(.labelSecondary)
                .padding(.bottom, 40)
            }
        }
    }

    private func statItem(_ number: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(number)
                .heroHeadlineStyle()
                .foregroundColor(.white)
            Text(label)
                .captionStyle()
                .foregroundColor(.labelSecondary)
        }
    }

    private func featureBadge(_ text: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .captionStyle()
                .foregroundColor(color)
            Text(text)
                .microStyle()
                .foregroundColor(.labelPrimary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.surfaceCard)
        .cornerRadius(8)
        .cardShadow()
    }
}
