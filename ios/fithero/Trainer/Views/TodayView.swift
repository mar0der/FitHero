import SwiftUI

struct TodayView: View {
    @State private var showNotifications = false
    let unreadCount = 3

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: FH.Spacing.xl) {
                    headerSection
                    sessionsSection
                    quickStatsSection
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xxxl)
            }
        }
        .sheet(isPresented: $showNotifications) {
            NotificationsView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: FH.Spacing.xs) {
                Text("Today")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                Text(dateString)
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            Spacer()

            Button {
                showNotifications = true
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(FH.Colors.textMuted)
                        .frame(width: 44, height: 44)
                        .background(FH.Colors.surface2)
                        .clipShape(Circle())

                    if unreadCount > 0 {
                        Text("\(min(unreadCount, 9))")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(FH.Colors.primaryInk)
                            .frame(width: 18, height: 18)
                            .background(FH.Colors.primary)
                            .clipShape(Circle())
                            .offset(x: 4, y: -4)
                    }
                }
            }
        }
        .padding(.top, FH.Spacing.lg)
    }

    // MARK: - Sessions

    private var sessionsSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack {
                Text("SESSIONS")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                Spacer()

                Text("3 scheduled")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            VStack(spacing: FH.Spacing.sm) {
                sessionRow(
                    name: "Alex Johnson",
                    time: "09:00",
                    type: "In-person",
                    duration: "60 min",
                    location: "FitStudio Downtown",
                    icon: "figure.walk",
                    iconColor: FH.Colors.accent,
                    isNext: true
                )
                sessionRow(
                    name: "Marco Rossi",
                    time: "11:30",
                    type: "Video call",
                    duration: "30 min",
                    location: nil,
                    icon: "video.fill",
                    iconColor: FH.Colors.primary,
                    isNext: false
                )
                sessionRow(
                    name: "Erika Szabo",
                    time: "16:00",
                    type: "Check-in",
                    duration: "15 min",
                    location: nil,
                    icon: "checkmark.message.fill",
                    iconColor: FH.Colors.success,
                    isNext: false
                )
            }
        }
        .fhCard()
    }

    private func sessionRow(
        name: String,
        time: String,
        type: String,
        duration: String,
        location: String?,
        icon: String,
        iconColor: Color,
        isNext: Bool
    ) -> some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(iconColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                HStack(spacing: FH.Spacing.xs) {
                    Text(time)
                    Text("·")
                    Text(type)
                    Text("·")
                    Text(duration)
                }
                .font(.system(size: 13))
                .foregroundStyle(FH.Colors.textMuted)
                if let loc = location {
                    Text(loc)
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
            }

            Spacer(minLength: 0)

            if isNext {
                Text("Next")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(FH.Colors.primaryInk)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(FH.Colors.primary)
                    .clipShape(Capsule())
            }
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(isNext ? FH.Colors.primary.opacity(0.35) : FH.Colors.border, lineWidth: 1)
        )
    }

    // MARK: - Quick Stats

    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("QUICK STATS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            HStack(spacing: FH.Spacing.sm) {
                statTile(value: "18", label: "Active clients", icon: "person.2.fill")
                statTile(value: "3", label: "Today", icon: "calendar", accent: true)
                statTile(value: "$2,340", label: "This week", icon: "dollarsign.circle.fill")
            }
        }
        .fhCard()
    }

    private func statTile(value: String, label: String, icon: String, accent: Bool = false) -> some View {
        VStack(spacing: FH.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(accent ? FH.Colors.primary : FH.Colors.textMuted)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(accent ? FH.Colors.primary : FH.Colors.text)
                .monospacedDigit()
            Text(label.uppercased())
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(0.6)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FH.Spacing.base)
        .background(FH.Colors.surface.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.md)
                .stroke(accent ? FH.Colors.primary.opacity(0.3) : FH.Colors.border, lineWidth: 1)
        )
    }

    // MARK: - Helpers

    private var dateString: String {
        Date().formatted(.dateTime.weekday(.wide).month(.wide).day())
    }
}

#Preview {
    TodayView()
        .preferredColorScheme(.dark)
}
