import SwiftUI

@main
struct VersalApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("darkModeOption") private var darkModeStorage = "System"
    @StateObject private var authService = AuthService()
    @Environment(\.scenePhase) private var scenePhase

    private var preferredColorScheme: ColorScheme? {
        switch darkModeStorage {
        case "Light": return .light
        case "Dark": return .dark
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            if !hasSeenOnboarding {
                OnboardingView()
            } else if authService.isAppLocked && authService.isFaceIDEnabled {
                LockScreenView(authService: authService)
            } else {
                mainTabView
                    .preferredColorScheme(preferredColorScheme)
                    .onChange(of: scenePhase) { _, newPhase in
                        if newPhase == .active && authService.isFaceIDEnabled {
                            Task {
                                authService.isAppLocked = true
                                _ = try? await authService.authenticateWithFaceID(reason: "Unlock Versal")
                                authService.isAppLocked = false
                            }
                        }
                    }
            }
        }
    }

    @AppStorage("selectedTab") private var selectedTab = 0

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            FilesView()
                .tabItem {
                    Label("Files", systemImage: "doc.on.doc")
                }
                .tag(1)

            ConvertView()
                .tabItem {
                    Label("Convert", systemImage: "arrow.triangle.2.circlepath")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(3)
        }
        .tint(.inkBlue)
    }
}
