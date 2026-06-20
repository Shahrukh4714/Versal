import SwiftUI

struct LockScreenView: View {
    @ObservedObject var authService: AuthService
    @State private var hasAttemptedAuth = false
    @State private var haptics = HapticService()

    var body: some View {
        ZStack {
            Color.darkSurface
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "faceid")
                    .font(.system(size: 64))
                    .foregroundColor(.inkBlue)

                Text("Versal is locked")
                    .heroHeadlineStyle()
                    .foregroundColor(.white)

                Text("Unlock Versal to access your files")
                    .bodyStyle()
                    .foregroundColor(.labelSecondary)

                Spacer()

                Button(action: { authenticate() }) {
                    Text("Unlock")
                        .bodyBoldStyle()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.inkBlue)
                        .cornerRadius(CornerRadius.button)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            if !hasAttemptedAuth {
                authenticate()
            }
        }
    }

    private func authenticate() {
        hasAttemptedAuth = true
        Task {
            do {
                let success = try await authService.authenticateWithFaceID(reason: "Unlock Versal")
                if success {
                    haptics.trigger(.success)
                    authService.isAppLocked = false
                } else {
                    haptics.trigger(.destructive)
                }
            } catch {
                haptics.trigger(.error)
                if let success = try? await authService.authenticateWithDevicePasscode(reason: "Unlock Versal"), success {
                    authService.isAppLocked = false
                }
            }
        }
    }
}

struct FaceIDSetupPrompt: View {
    @Binding var isPresented: Bool
    let onEnable: () -> Void
    let onNotNow: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "faceid")
                .font(.system(size: 48))
                .foregroundColor(.inkBlue)
                .accessibilityLabel("Face ID")

            Text("Lock Versal with Face ID?")
                .sectionHeaderStyle()
                .foregroundColor(.labelPrimary)

            Text("Secure the app so only you can access your files.")
                .bodyStyle()
                .foregroundColor(.labelSecondary)
                .multilineTextAlignment(.center)

            Button(action: { onEnable(); isPresented = false }) {
                Text("Enable")
                    .bodyBoldStyle()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.inkBlue)
                    .cornerRadius(CornerRadius.button)
            }

            Button(action: { onNotNow(); isPresented = false }) {
                Text("Not Now")
                    .bodyStyle()
                    .foregroundColor(.labelSecondary)
            }
        }
        .padding(24)
        .background(Color.surfaceCard)
        .cornerRadius(CornerRadius.card)
        .padding(.horizontal, 40)
    }
}
