import SwiftUI

struct NotificationsView: View {
    @State private var notifications = [
        NotifItem(title: "Workout completed", detail: "Alex finished Upper Body Strength", time: "10m ago", icon: "checkmark.circle.fill", color: FH.Colors.success, isUnread: true),
        NotifItem(title: "Payment received", detail: "Marco paid $320 for April sessions", time: "1h ago", icon: "dollarsign.circle.fill", color: FH.Colors.primary, isUnread: true),
        NotifItem(title: "New message", detail: "Erika: 'Hit a new PR on deadlifts'", time: "3h ago", icon: "message.fill", color: FH.Colors.accent, isUnread: true),
        NotifItem(title: "Session reminder", detail: "Alex in-person at 09:00 tomorrow", time: "5h ago", icon: "calendar.badge.clock", color: FH.Colors.warning, isUnread: false),
        NotifItem(title: "Client paused", detail: "Sam paused their subscription", time: "2d ago", icon: "pause.circle.fill", color: FH.Colors.textSubtle, isUnread: false),
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
                Text("\(unreadCount) unread")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            Spacer()
            Button {
                FHHaptics.light()
                for index in notifications.indices {
                    notifications[index].isUnread = false
                }
            } label: {
                Text("Mark all read")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(unreadCount > 0 ? FH.Colors.primary : FH.Colors.textSubtle)
            }
            .disabled(unreadCount == 0)
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

    private var unreadCount: Int {
        notifications.filter(\.isUnread).count
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
                        .font(.system(size: 15, weight: notif.isUnread ? .bold : .semibold))
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

            if notif.isUnread {
                Circle()
                    .fill(FH.Colors.primary)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(FH.Spacing.md)
        .background(notif.isUnread ? FH.Colors.primary.opacity(0.03) : Color.clear)
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
    var isUnread: Bool
}

#Preview {
    NotificationsView()
        .preferredColorScheme(.dark)
}
