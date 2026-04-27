import SwiftUI

struct AuthSignInView: View {
    @AppStorage("selectedAppRole") private var selectedRoleRawValue = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    brandHeader
                        .padding(.top, FH.Spacing.huge)

                    signInForm
                        .padding(.top, FH.Spacing.xxl)

                    dividerWithOr
                        .padding(.top, FH.Spacing.lg)

                    ssoSection
                        .padding(.top, FH.Spacing.lg)

                    Spacer(minLength: FH.Spacing.xxxl)
                }
                .padding(.horizontal, FH.Spacing.base)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var brandHeader: some View {
        VStack(spacing: FH.Spacing.xl) {
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .fill(FH.Colors.primary)
                .frame(width: 48, height: 48)
                .overlay(
                    Text("FH")
                        .font(.system(size: 16, weight: .black))
                        .foregroundStyle(FH.Colors.primaryInk)
                )

            VStack(spacing: FH.Spacing.sm) {
                Text("Sign in to your account")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(FH.Colors.text)

                Text("Welcome back.")
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.textMuted)
            }
        }
    }

    private var signInForm: some View {
        VStack(spacing: FH.Spacing.lg) {
            VStack(spacing: FH.Spacing.md) {
                authInputField(
                    label: "Email",
                    text: $email,
                    placeholder: "you@example.com",
                    keyboard: .emailAddress
                )

                authInputField(
                    label: "Password",
                    text: $password,
                    placeholder: "Enter your password",
                    isSecure: true
                )
            }

            VStack(spacing: FH.Spacing.md) {
                Button {
                    signIn()
                } label: {
                    Text("Sign in")
                }
                .buttonStyle(FHPrimaryButtonStyle())

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
    }

    private var ssoSection: some View {
        VStack(spacing: FH.Spacing.sm) {
            SignInWithAppleButton {
                signIn()
            }

            SignInWithGoogleButton {
                signIn()
            }
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



    private func signIn() {
        // In production: call backend auth, receive role + onboarding status
        // For prototype: default to client role if email contains "client" or "hero",
        // trainer role if email contains "trainer", otherwise client
        if email.lowercased().contains("trainer") {
            selectedRoleRawValue = AppRole.trainer.rawValue
        } else {
            selectedRoleRawValue = AppRole.client.rawValue
            hasCompletedOnboarding = true
        }
    }
}

#Preview {
    NavigationStack {
        AuthSignInView()
    }
}
