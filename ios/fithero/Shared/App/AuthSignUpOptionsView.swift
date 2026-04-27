import SwiftUI

struct AuthSignUpOptionsView: View {
    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                brandSection

                Spacer()

                optionsSection
            }
        }
        .preferredColorScheme(.dark)
    }

    private var brandSection: some View {
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
                Text("How would you like to join?")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(FH.Colors.text)

                Text("Choose the path that fits you.")
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.textMuted)
            }
        }
    }

    private var optionsSection: some View {
        VStack(spacing: FH.Spacing.sm) {
            NavigationLink {
                ClientAuthView()
            } label: {
                optionCard(
                    icon: "envelope.badge.person.fill",
                    title: "I was invited by a trainer",
                    subtitle: "Your coach sent you an invite link."
                )
            }

            NavigationLink {
                TrainerAuthView(isSignUpMode: true)
            } label: {
                optionCard(
                    icon: "dumbbell.fill",
                    title: "I'm a trainer",
                    subtitle: "Create your coach account."
                )
            }

            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.textMuted)

                NavigationLink {
                    AuthSignInView()
                } label: {
                    Text("Sign in")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(FH.Colors.primary)
                }
            }
            .padding(.top, FH.Spacing.md)
        }
        .padding(.horizontal, FH.Spacing.xl)
        .padding(.bottom, 52)
    }

    private func optionCard(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(FH.Colors.surface2)
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(FH.Colors.text)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        AuthSignUpOptionsView()
    }
}
