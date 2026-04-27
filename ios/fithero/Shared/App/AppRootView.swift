import SwiftUI

enum AppRole: String {
    case trainer
    case client
}

struct AppRootView: View {
    @AppStorage("selectedAppRole") private var selectedRoleRawValue = ""

    private var selectedRole: AppRole? {
        get { AppRole(rawValue: selectedRoleRawValue) }
        set { selectedRoleRawValue = newValue?.rawValue ?? "" }
    }

    var body: some View {
        ZStack {
            Group {
                switch selectedRole {
                case .trainer:
                    TrainerRootView(onSignOut: { selectedRoleRawValue = "" })
                case .client:
                    ClientRootView(onSignOut: { selectedRoleRawValue = "" })
                case nil:
                    RoleSelectionView(
                        onSelectTrainer: { selectedRoleRawValue = AppRole.trainer.rawValue },
                        onSelectClient: { selectedRoleRawValue = AppRole.client.rawValue }
                    )
                }
            }
        }
    }
}

private struct RoleSelectionView: View {
    let onSelectTrainer: () -> Void
    let onSelectClient: () -> Void

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Mark
                VStack(spacing: FH.Spacing.base) {
                    RoundedRectangle(cornerRadius: FH.Radius.lg)
                        .fill(FH.Colors.primary)
                        .frame(width: 64, height: 64)
                        .overlay(
                            Text("FH")
                                .font(.system(size: 22, weight: .black))
                                .foregroundStyle(FH.Colors.primaryInk)
                        )

                    Text("FitHero")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                        .tracking(-1)
                }

                Spacer()

                // Buttons
                VStack(spacing: FH.Spacing.sm) {
                    Button("Trainer", action: onSelectTrainer)
                        .buttonStyle(FHPrimaryButtonStyle())

                    Button("Hero", action: onSelectClient)
                        .buttonStyle(FHSecondaryButtonStyle())

                    Text("DEMO · NO AUTH")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(FH.Colors.textSubtle)
                        .tracking(1.2)
                        .padding(.top, FH.Spacing.xs)
                }
                .padding(.horizontal, FH.Spacing.xl)
                .padding(.bottom, 52)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AppRootView()
}
