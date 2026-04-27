import SwiftUI

struct NotificationsView: View {
    let notifications = [
        NotifItem(title: "Workout completed", detail: "Alex finished Upper Body Strength", time: "10m ago", icon: "checkmark.circle.fill", color: FH.Colors.success),
        NotifItem(title: "Payment received", detail: "Marco paid $320 for April sessions", time: "1h ago", icon: "dollarsign.circle.fill", color: FH.Colors.primary),
        NotifItem(title: "New message", detail: "Erika: 'Hit a new PR on deadlifts'", time: "3h ago", icon: "message.fill", color: FH.Colors.accent),
        NotifItem(title: "Session reminder", detail: "Alex in-person at 09:00 tomorrow", time: "5h ago", icon: "calendar.badge.clock", color: FH.Colors.warning),
        NotifItem(title: "Client paused", detail: "Sam paused their subscription", time: "2d ago", icon: "pause.circle.fill", color: FH.Colors.textSubtle),
    ]

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                sheetHandle

                ScrollView(showsIndicators: false) {
                    VStack(spacing: FH.Spacing.xl) {
                        headerSection
                        notificationList
                    }
                    .padding(.horizontal, FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
        }
    }

    // MARK: - Handle

    private var sheetHandle: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.white.opacity(0.2))
            .frame(width: 38, height: 5)
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
            .padding(.bottom, FH.Spacing.md)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: FH.Spacing.xs) {
                Text("Notifications")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                Text("\(notifications.count) recent")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            Spacer()
            Button {
                // Mark all read
            } label: {
                Text("Mark all read")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(FH.Colors.primary)
            }
        }
    }

    // MARK: - List

    private var notificationList: some View {
        VStack(spacing: 0) {
            ForEach(Array(notifications.enumerated()), id: \.element.id) { index, notif in
                notificationRow(notif)
                if index < notifications.count - 1 {
                    Divider()
                        .background(FH.Colors.border)
                        .padding(.leading, 60)
                }
            }
        }
        .fhCard()
    }

    private func notificationRow(_ notif: NotifItem) -> some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(notif.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: notif.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(notif.color)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(notif.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(FH.Colors.text)
                    Spacer()
                    Text(notif.time)
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
                Text(notif.detail)
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.textMuted)
                    .lineLimit(2)
            }
        }
        .padding(FH.Spacing.md)
    }
}

// MARK: - Model

struct NotifItem: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let time: String
    let icon: String
    let color: Color
}

#Preview {
    NotificationsView()
        .preferredColorScheme(.dark)
}
