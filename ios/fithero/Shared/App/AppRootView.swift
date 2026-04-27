import SwiftUI

enum AppRole: String {
    case trainer
    case client
}

struct AppRootView: View {
    @AppStorage("selectedAppRole") private var selectedRoleRawValue = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    private var selectedRole: AppRole? {
        get { AppRole(rawValue: selectedRoleRawValue) }
        set { selectedRoleRawValue = newValue?.rawValue ?? "" }
    }

    var body: some View {
        ZStack {
            Group {
                switch selectedRole {
                case .trainer:
                    TrainerRootView(onSignOut: signOut)
                case .client:
                    if hasCompletedOnboarding {
                        ClientRootView(onSignOut: signOut)
                    } else {
                        ClientOnboardingView {
                            hasCompletedOnboarding = true
                        }
                    }
                case nil:
                    NavigationStack {
                        AuthLandingView()
                    }
                }
            }
        }
    }

    private func signOut() {
        selectedRoleRawValue = ""
    }
}

#Preview {
    AppRootView()
}
