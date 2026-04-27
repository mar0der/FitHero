import SwiftUI

struct AuthLandingView: View {
    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                brandSection

                Spacer()

                actionSection
            }
        }
        .preferredColorScheme(.dark)
    }

    private var brandSection: some View {
        VStack(spacing: FH.Spacing.lg) {
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

            Text("Training, simplified.")
                .font(.system(size: 17))
                .foregroundStyle(FH.Colors.textMuted)
        }
    }

    private var actionSection: some View {
        VStack(spacing: FH.Spacing.sm) {
            NavigationLink {
                AuthSignInView()
            } label: {
                Text("Sign In")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(FH.Colors.primaryInk)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(FH.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            }

            NavigationLink {
                AuthSignUpOptionsView()
            } label: {
                Text("Get Started")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(FH.Colors.text)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(FH.Colors.surface2)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                    .overlay(
                        RoundedRectangle(cornerRadius: FH.Radius.md)
                            .stroke(FH.Colors.border, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, FH.Spacing.xl)
        .padding(.bottom, 52)
    }
}

#Preview {
    NavigationStack {
        AuthLandingView()
    }
}
