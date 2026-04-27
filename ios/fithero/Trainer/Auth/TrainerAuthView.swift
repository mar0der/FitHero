import SwiftUI

struct TrainerAuthView: View {
    @AppStorage("selectedAppRole") private var selectedRoleRawValue = ""

    @State private var name = ""
    @State private var businessName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUpMode: Bool

    init(isSignUpMode: Bool = false) {
        _isSignUpMode = State(initialValue: isSignUpMode)
    }

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    brandHeader
                        .padding(.top, FH.Spacing.huge)

                    authForm
                        .padding(.top, FH.Spacing.xxl)

                    Spacer(minLength: FH.Spacing.xxxl)
                }
                .padding(.horizontal, FH.Spacing.base)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Brand Header

    private var brandHeader: some View {
        VStack(spacing: FH.Spacing.xl) {
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

            VStack(spacing: FH.Spacing.sm) {
                Text(isSignUpMode ? "Create trainer account" : "Trainer sign in")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(FH.Colors.text)

                Text(isSignUpMode ? "Start coaching on FitHero." : "Welcome back, coach.")
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.textMuted)
            }
        }
    }

    // MARK: - Auth Form

    private var authForm: some View {
        VStack(spacing: FH.Spacing.lg) {
            VStack(spacing: FH.Spacing.md) {
                if isSignUpMode {
                    authInputField(
                        label: "Full name",
                        text: $name,
                        placeholder: "Maya Johnson"
                    )

                    authInputField(
                        label: "Business / Gym name",
                        text: $businessName,
                        placeholder: "FitStudio Downtown"
                    )
                }

                authInputField(
                    label: "Email",
                    text: $email,
                    placeholder: "coach@fithero.com",
                    keyboard: .emailAddress
                )

                authInputField(
                    label: "Password",
                    text: $password,
                    placeholder: isSignUpMode ? "Min 8 characters" : "Enter your password",
                    isSecure: true
                )
            }

            VStack(spacing: FH.Spacing.md) {
                Button {
                    completeAuth()
                } label: {
                    Text(isSignUpMode ? "Create account" : "Sign in")
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

    private func completeAuth() {
        selectedRoleRawValue = AppRole.trainer.rawValue
    }
}

#Preview {
    TrainerAuthView()
        .preferredColorScheme(.dark)
}
