import SwiftUI

struct ClientAuthView: View {
    @AppStorage("selectedAppRole") private var selectedRoleRawValue = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @State private var inviteCode = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUpMode = true
    @State private var hasValidatedInvite = true // In production: validate from deep link

    private let trainer = SampleData.onboardingTrainer

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    if hasValidatedInvite {
                        inviteHeader
                            .padding(.top, FH.Spacing.huge)
                    } else {
                        inviteCodeSection
                            .padding(.top, FH.Spacing.huge)
                    }

                    authForm
                        .padding(.top, FH.Spacing.xxl)

                    Spacer(minLength: FH.Spacing.xxxl)
                }
                .padding(.horizontal, FH.Spacing.base)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Invite Code (no deep link)

    private var inviteCodeSection: some View {
        VStack(spacing: FH.Spacing.xl) {
            VStack(spacing: FH.Spacing.base) {
                Text("Welcome to FitHero")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(FH.Colors.text)

                Text("Enter your invite code to get started")
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.textMuted)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: FH.Spacing.md) {
                authInputField(
                    label: "Invite code",
                    text: $inviteCode,
                    placeholder: "ABC-123-XYZ",
                    keyboard: .asciiCapable
                )

                Button {
                    // In production: validate invite code with backend
                    hasValidatedInvite = true
                } label: {
                    Text("Validate invite")
                }
                .buttonStyle(FHPrimaryButtonStyle())
            }
        }
    }

    // MARK: - Invite Header (validated)

    private var inviteHeader: some View {
        VStack(spacing: FH.Spacing.xl) {
            ZStack {
                Circle()
                    .fill(FH.Colors.primary.opacity(0.15))
                    .frame(width: 80, height: 80)
                Text(trainer.photoInitial)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(FH.Colors.primary)
            }

            VStack(spacing: FH.Spacing.sm) {
                Text("\(trainer.name) invited you")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                    .multilineTextAlignment(.center)

                Text("to train together on FitHero")
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.textMuted)
                    .multilineTextAlignment(.center)
            }

            Text(trainer.inviteMessage)
                .font(.system(size: 15))
                .foregroundStyle(FH.Colors.textMuted)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, FH.Spacing.lg)
        }
    }

    // MARK: - Auth Form

    private var authForm: some View {
        VStack(spacing: FH.Spacing.lg) {
            VStack(spacing: FH.Spacing.md) {
                authInputField(
                    label: "Email",
                    text: $email,
                    placeholder: "alex@example.com",
                    keyboard: .emailAddress
                )

                authInputField(
                    label: "Password",
                    text: $password,
                    placeholder: "Min 8 characters",
                    isSecure: true
                )
            }

            VStack(spacing: FH.Spacing.md) {
                Button {
                    completeAuth()
                } label: {
                    Text(isSignUpMode ? "Accept & set up" : "Sign in")
                }
                .buttonStyle(FHPrimaryButtonStyle())

                if !isSignUpMode {
                    Button {
                        // Forgot password stub
                    } label: {
                        Text("Forgot password?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(FH.Colors.accent)
                    }
                    .buttonStyle(.plain)
                }
            }

            dividerWithOr

            VStack(spacing: FH.Spacing.sm) {
                ssoButton(icon: "apple.logo", title: "Continue with Apple", action: {
                    completeAuth()
                })
                ssoButton(icon: "g.circle.fill", title: "Continue with Google", action: {
                    completeAuth()
                })
            }

            HStack(spacing: 4) {
                Text(isSignUpMode ? "Already have an account?" : "New to FitHero?")
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.textMuted)

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSignUpMode.toggle()
                    }
                } label: {
                    Text(isSignUpMode ? "Sign in" : "Create account")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(FH.Colors.primary)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, FH.Spacing.md)
        }
    }

    private var dividerWithOr: some View {
        HStack(spacing: FH.Spacing.md) {
            Divider().background(FH.Colors.border)
            Text("or")
                .font(.system(size: 13))
                .foregroundStyle(FH.Colors.textSubtle)
            Divider().background(FH.Colors.border)
        }
    }

    // MARK: - Helpers

    private func authInputField(
        label: String,
        text: Binding<String>,
        placeholder: String,
        keyboard: UIKeyboardType = .default,
        isSecure: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            Text(label.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            Group {
                if isSecure {
                    SecureField(placeholder, text: text)
                } else {
                    TextField(placeholder, text: text)
                        .keyboardType(keyboard)
                }
            }
            .font(.system(size: 17, weight: .medium))
            .foregroundStyle(FH.Colors.text)
            .padding(.horizontal, FH.Spacing.md)
            .padding(.vertical, FH.Spacing.md)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )
        }
    }

    private func ssoButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: FH.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(FH.Colors.text)
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(FH.Colors.text)
                Spacer()
            }
            .padding(.horizontal, FH.Spacing.md)
            .padding(.vertical, FH.Spacing.md)
            .background(FH.Colors.surface2)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func completeAuth() {
        selectedRoleRawValue = AppRole.client.rawValue
        if isSignUpMode {
            hasCompletedOnboarding = false
        } else {
            hasCompletedOnboarding = true
        }
    }
}

#Preview {
    ClientAuthView()
        .preferredColorScheme(.dark)
}
