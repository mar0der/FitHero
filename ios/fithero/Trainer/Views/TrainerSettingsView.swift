import SwiftUI

struct TrainerSettingsView: View {
    let onSignOut: () -> Void

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: FH.Spacing.xl) {
                    headerSection
                    profileSection
                    preferencesSection
                    supportSection
                    dangerSection
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xxxl)
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: FH.Spacing.xs) {
                Text("Settings")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                Text("Maya · Pro plan")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            Spacer()
        }
        .padding(.top, FH.Spacing.lg)
    }

    // MARK: - Profile

    private var profileSection: some View {
        VStack(spacing: FH.Spacing.sm) {
            settingsRow(icon: "person.fill", iconColor: FH.Colors.accent, title: "Edit Profile", subtitle: "Name, photo, bio, timezone")
            settingsRow(icon: "creditcard.fill", iconColor: FH.Colors.primary, title: "Billing", subtitle: "Your FitHero subscription")
            settingsRow(icon: "paintbrush.fill", iconColor: FH.Colors.warning, title: "Branding", subtitle: "Logo preview, accent color")
        }
    }

    // MARK: - Preferences

    private var preferencesSection: some View {
        VStack(spacing: FH.Spacing.sm) {
            ToggleRow(icon: "bell.fill", iconColor: FH.Colors.success, title: "Push Notifications")
            ToggleRow(icon: "envelope.fill", iconColor: FH.Colors.accent, title: "Email Notifications")
            settingsRow(icon: "globe", iconColor: FH.Colors.textMuted, title: "Language & Region", subtitle: "English · EST")
        }
    }

    // MARK: - Support

    private var supportSection: some View {
        VStack(spacing: FH.Spacing.sm) {
            settingsRow(icon: "questionmark.circle.fill", iconColor: FH.Colors.textMuted, title: "Help & Support", subtitle: nil)
            settingsRow(icon: "doc.text.fill", iconColor: FH.Colors.textMuted, title: "Terms & Privacy", subtitle: nil)
        }
    }

    // MARK: - Danger

    private var dangerSection: some View {
        Button {
            onSignOut()
        } label: {
            HStack {
                Image(systemName: "arrow.left.square.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(FH.Colors.danger)
                Text("Sign Out")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(FH.Colors.danger)
                Spacer()
            }
            .padding(FH.Spacing.md)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    private func settingsRow(icon: String, iconColor: Color, title: String, subtitle: String?) -> some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(FH.Colors.text)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(FH.Colors.textMuted)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
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

// MARK: - Toggle Row

private struct ToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @State private var isOn = true

    var body: some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(iconColor)
            }

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(FH.Colors.text)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(FH.Colors.primary)
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
    TrainerSettingsView(onSignOut: {})
        .preferredColorScheme(.dark)
}
