import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            List {
                accountSection
                subscriptionSection
                securitySection
                defaultsSection
                appearanceSection
                syncSection
                aboutSection
            }
            .background(Color.backgroundGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
        }
    }

    private var accountSection: some View {
        Section {
            HStack(spacing: 12) {
                LogomarkInline()
                VStack(alignment: .leading, spacing: 2) {
                    Text("No account")
                        .bodyBoldStyle()
                    Text("Your data stays on this device")
                        .captionStyle()
                        .foregroundColor(.labelSecondary)
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var subscriptionSection: some View {
        Section("Subscription") {
            HStack {
                Text("Current Plan")
                    .bodyStyle()
                Spacer()
                Text(viewModel.subscriptionTier.rawValue.capitalized)
                    .captionStyle()
                    .foregroundColor(viewModel.subscriptionTier.isPro ? .successGreen : .labelSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(viewModel.subscriptionTier.isPro ? Color.successGreen.opacity(0.1) : Color.inkWash)
                    .cornerRadius(8)
            }

            if viewModel.subscriptionTier == .pro {
                Button("Manage Subscription") {}
                    .bodyStyle()
                    .foregroundColor(.inkBlue)
            }

            Button("Restore Purchase") {
                viewModel.restorePurchase()
            }
            .bodyStyle()
            .foregroundColor(.inkBlue)
        }
    }

    private var securitySection: some View {
        Section("Security") {
            Toggle(isOn: $viewModel.isFaceIDEnabled) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Face ID Lock")
                        .bodyStyle()
                    Text("Lock Versal with Face ID when app returns from background")
                        .captionStyle()
                        .foregroundColor(.labelSecondary)
                }
            }
            .onChange(of: viewModel.isFaceIDEnabled) { _, _ in
                viewModel.toggleFaceID()
            }
            .tint(.inkBlue)

            Toggle(isOn: $viewModel.isPasswordProtectEnabled) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Password-Protect Files")
                        .bodyStyle()
                    Text("Lock individual files with Face ID")
                        .captionStyle()
                        .foregroundColor(.labelSecondary)
                }
            }
            .tint(.inkBlue)
        }
    }

    private var defaultsSection: some View {
        Section("Defaults") {
            HStack {
                Text("Default Export Format")
                    .bodyStyle()
                Spacer()
                Picker("", selection: $viewModel.defaultExportFormat) {
                    Text("PDF").tag("PDF")
                    Text("JPG").tag("JPG")
                    Text("PNG").tag("PNG")
                }
                .pickerStyle(.menu)
                .tint(.inkBlue)
            }
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Dark Mode", selection: $viewModel.darkModeStorage) {
                ForEach(SettingsViewModel.DarkModeOption.allCases, id: \.rawValue) { option in
                    Text(option.rawValue).tag(option.rawValue)
                }
            }
            .tint(.inkBlue)
        }
    }

    private var syncSection: some View {
        Section("Sync") {
            Toggle(isOn: $viewModel.isICloudSyncEnabled) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("iCloud Sync")
                        .bodyStyle()
                    Text("Sync files across your Apple devices via iCloud Drive")
                        .captionStyle()
                        .foregroundColor(.labelSecondary)
                }
            }
            .tint(.inkBlue)
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                LogomarkContainer(size: 28)
                VStack(alignment: .leading) {
                    Text("Versal")
                        .bodyBoldStyle()
                    Text("Version 1.0")
                        .captionStyle()
                        .foregroundColor(.labelSecondary)
                }
            }

            Button("Support / Contact") {}
                .bodyStyle()
                .foregroundColor(.inkBlue)

            Button("Privacy Policy") {}
                .bodyStyle()
                .foregroundColor(.inkBlue)
        }
    }
}
