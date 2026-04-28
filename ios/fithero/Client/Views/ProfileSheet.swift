import SwiftUI

struct ProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onSignOut: () -> Void
    @AppStorage("clientName") private var clientName = "Alex Johnson"
    @AppStorage("clientAge") private var clientAge = "28"
    @AppStorage("clientHeight") private var clientHeight = "180"
    @AppStorage("clientWeight") private var clientWeight = "79.8"
    @AppStorage("notifyWorkouts") private var notifyWorkouts = true
    @AppStorage("notifyMessages") private var notifyMessages = true
    @AppStorage("notifyProgress") private var notifyProgress = false

    @State private var showPayments = false

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: FH.Spacing.xl) {
                        avatarHeader
                        infoSection
                        paymentsSection
                        notificationsSection
                        supportSection
                        signOutButton
                    }
                    .padding(.horizontal, FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .navigationTitle("Profile")
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
            .navigationDestination(isPresented: $showPayments) {
                PaymentsView()
            }
        }
    }

    // MARK: - Avatar Header

    private var avatarHeader: some View {
        VStack(spacing: FH.Spacing.md) {
            ZStack {
                Circle()
                    .fill(FH.Colors.primary.opacity(0.15))
                    .frame(width: 88, height: 88)
                Text(SampleData.clientAvatar)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(FH.Colors.primary)
            }

            VStack(spacing: FH.Spacing.xs) {
                Text(clientName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                Text("Starter — 2×/week")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FH.Spacing.xl)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("PERSONAL INFO")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            VStack(spacing: FH.Spacing.sm) {
                fieldRow(icon: "person.fill", iconColor: FH.Colors.accent, title: "Name", value: $clientName, keyboard: .default)
                fieldRow(icon: "number", iconColor: FH.Colors.primary, title: "Age", value: $clientAge, keyboard: .numberPad)
                fieldRow(icon: "ruler", iconColor: FH.Colors.warning, title: "Height (cm)", value: $clientHeight, keyboard: .decimalPad)
                fieldRow(icon: "scalemass", iconColor: FH.Colors.success, title: "Weight (kg)", value: $clientWeight, keyboard: .decimalPad)
            }
        }
    }

    private func fieldRow(icon: String, iconColor: Color, title: String, value: Binding<String>, keyboard: UIKeyboardType) -> some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(iconColor)
            }

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(FH.Colors.text)

            Spacer()

            TextField(title, text: value)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(FH.Colors.primary)
                .multilineTextAlignment(.trailing)
                .keyboardType(keyboard)
                .monospacedDigit()
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
    }

    // MARK: - Payments

    private var paymentsSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("BILLING")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            Button {
                FHHaptics.light()
                showPayments = true
            } label: {
                HStack(spacing: FH.Spacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: FH.Radius.md)
                            .fill(FH.Colors.primary.opacity(0.12))
                            .frame(width: 36, height: 36)
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(FH.Colors.primary)
                    }

                    Text("Payments & Plans")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(FH.Colors.text)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
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
            .buttonStyle(.plain)
        }
    }

    // MARK: - Notifications

    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("NOTIFICATIONS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            VStack(spacing: FH.Spacing.sm) {
                ProfileToggleRow(icon: "dumbbell.fill", iconColor: FH.Colors.primary, title: "Workout Reminders", isOn: $notifyWorkouts)
                ProfileToggleRow(icon: "message.fill", iconColor: FH.Colors.accent, title: "Messages", isOn: $notifyMessages)
                ProfileToggleRow(icon: "chart.line.uptrend.xyaxis", iconColor: FH.Colors.success, title: "Progress Updates", isOn: $notifyProgress)
            }
        }
    }

    // MARK: - Support

    private var supportSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("SUPPORT")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            VStack(spacing: FH.Spacing.sm) {
                Link(destination: URL(string: "mailto:support@fithero.app")!) {
                    HStack(spacing: FH.Spacing.md) {
                        ZStack {
                            RoundedRectangle(cornerRadius: FH.Radius.md)
                                .fill(FH.Colors.textMuted.opacity(0.12))
                                .frame(width: 36, height: 36)
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(FH.Colors.textMuted)
                        }

                        Text("Help & Support")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(FH.Colors.text)

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 14))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }
                    .padding(FH.Spacing.md)
                    .background(FH.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                }

                Link(destination: URL(string: "https://fithero.app/privacy")!) {
                    HStack(spacing: FH.Spacing.md) {
                        ZStack {
                            RoundedRectangle(cornerRadius: FH.Radius.md)
                                .fill(FH.Colors.textMuted.opacity(0.12))
                                .frame(width: 36, height: 36)
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(FH.Colors.textMuted)
                        }

                        Text("Terms & Privacy")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(FH.Colors.text)

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 14))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }
                    .padding(FH.Spacing.md)
                    .background(FH.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                }
            }
        }
    }

    // MARK: - Sign Out

    private var signOutButton: some View {
        Button {
            FHHaptics.medium()
            dismiss()
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
}

// MARK: - Profile Toggle Row

struct ProfileToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(iconColor)
            }

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(FH.Colors.text)

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(FH.Colors.primary)
                .labelsHidden()
                .onChange(of: isOn) { _, _ in
                    FHHaptics.selection()
                }
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
    }
}


