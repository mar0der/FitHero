import SwiftUI

struct ForgotPasswordSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var showConfirmation = false

    private var isValid: Bool {
        email.contains("@") && email.contains(".")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                VStack(spacing: FH.Spacing.xl) {
                    header

                    if showConfirmation {
                        confirmationView
                    } else {
                        formView
                    }

                    Spacer()
                }
                .padding(FH.Spacing.base)
            }
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .fill(FH.Colors.primary.opacity(0.12))
                    .frame(width: 72, height: 72)
                Image(systemName: "lock.rotation")
                    .font(.system(size: 32))
                    .foregroundStyle(FH.Colors.primary)
            }

            Text("Forgot your password?")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(FH.Colors.text)
                .multilineTextAlignment(.center)

            Text("Enter your email and we'll send you a link to reset your password.")
                .font(.system(size: 14))
                .foregroundStyle(FH.Colors.textMuted)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .padding(.top, FH.Spacing.lg)
    }

    // MARK: - Form

    private var formView: some View {
        VStack(spacing: FH.Spacing.xl) {
            VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                Text("EMAIL")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                TextField("you@example.com", text: $email)
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.text)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal, FH.Spacing.md)
                    .padding(.vertical, FH.Spacing.sm)
                    .background(FH.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                    .overlay(
                        RoundedRectangle(cornerRadius: FH.Radius.md)
                            .stroke(FH.Colors.border, lineWidth: 1)
                    )
            }

            Button {
                FHHaptics.success()
                showConfirmation = true
            } label: {
                Text("Send Reset Link")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(FH.Colors.primaryInk)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isValid ? FH.Colors.primary : FH.Colors.primary.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            }
            .disabled(!isValid)
        }
    }

    // MARK: - Confirmation

    private var confirmationView: some View {
        VStack(spacing: FH.Spacing.xl) {
            VStack(spacing: FH.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(FH.Colors.success.opacity(0.15))
                        .frame(width: 64, height: 64)
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(FH.Colors.success)
                }

                Text("Check your email")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(FH.Colors.text)

                Text("We've sent a password reset link to \(email). Tap the link in the email to create a new password.")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Button {
                dismiss()
            } label: {
                Text("Back to Sign In")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(FH.Colors.primaryInk)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(FH.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            }
        }
    }
}

#Preview {
    ForgotPasswordSheet()
        .preferredColorScheme(.dark)
}
