import SwiftUI

struct ClientDetailView: View {
    let client: ClientItem
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss

    let tabs = ["Overview", "Programs", "Progress", "Notes"]

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: FH.Spacing.xl) {
                    headerSection
                    actionButtons
                    tabSegmentedControl

                    switch selectedTab {
                    case 0: overviewTab
                    case 1: programsTab
                    case 2: progressTab
                    case 3: notesTab
                    default: EmptyView()
                    }
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xxxl)
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                Circle()
                    .fill(client.statusColor.opacity(0.15))
                    .frame(width: 64, height: 64)
                Text(client.initials)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(client.statusColor)
            }

            VStack(alignment: .leading, spacing: FH.Spacing.xs) {
                Text(client.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(FH.Colors.text)

                HStack(spacing: FH.Spacing.sm) {
                    statusPill(client.status)
                    Text(client.plan)
                        .font(.system(size: 13))
                        .foregroundStyle(FH.Colors.textMuted)
                }
            }

            Spacer(minLength: 0)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
                    .frame(width: 34, height: 34)
                    .background(FH.Colors.surface2)
                    .clipShape(Circle())
            }
        }
        .padding(.top, FH.Spacing.lg)
    }

    private func statusPill(_ status: String) -> some View {
        let color: Color
        switch status {
        case "Active": color = FH.Colors.success
        case "Pending": color = FH.Colors.warning
        case "Paused": color = FH.Colors.textSubtle
        default: color = FH.Colors.textSubtle
        }

        return Text(status)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }

    // MARK: - Quick Actions

    private var actionButtons: some View {
        HStack(spacing: FH.Spacing.sm) {
            actionButton(icon: "message.fill", label: "Message", color: FH.Colors.accent)
            actionButton(icon: "calendar.badge.plus", label: "Schedule", color: FH.Colors.primary)
            actionButton(icon: "doc.text.fill", label: "Assign", color: FH.Colors.warning)
        }
    }

    private func actionButton(icon: String, label: String, color: Color) -> some View {
        Button {
            // Action stub
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: FH.Radius.md)
                        .fill(color.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(color)
                }
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Segmented Control

    private var tabSegmentedControl: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, title in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                } label: {
                    Text(title)
                        .font(.system(size: 13, weight: selectedTab == index ? .semibold : .medium))
                        .foregroundStyle(selectedTab == index ? FH.Colors.primaryInk : FH.Colors.textMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedTab == index ? FH.Colors.primary : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
    }

    // MARK: - Overview Tab

    private var overviewTab: some View {
        VStack(spacing: FH.Spacing.xl) {
            // Goals
            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("GOALS")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                    goalRow(icon: "target", text: "Lose 6 kg, build lean muscle")
                    goalRow(icon: "figure.walk", text: "Train 4× per week consistently")
                    goalRow(icon: "heart.fill", text: "Improve cardiovascular health")
                }
            }
            .fhCard()

            // Quick Stats
            HStack(spacing: FH.Spacing.sm) {
                statTile(value: "12", label: "Workouts done", icon: "dumbbell.fill")
                statTile(value: "3", label: "Sessions this week", icon: "calendar", accent: true)
                statTile(value: "2.5 kg", label: "Weight change", icon: "arrow.down.circle.fill")
            }

            // Next Session
            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("NEXT SESSION")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                HStack(spacing: FH.Spacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: FH.Radius.md)
                            .fill(FH.Colors.accent.opacity(0.15))
                            .frame(width: 44, height: 44)
                        Image(systemName: "figure.walk")
                            .font(.system(size: 18))
                            .foregroundStyle(FH.Colors.accent)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("In-person with \(client.firstName)")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(FH.Colors.text)
                        Text("Tomorrow · 09:00 · 60 min")
                            .font(.system(size: 13))
                            .foregroundStyle(FH.Colors.textMuted)
                        Text("FitStudio Downtown")
                            .font(.system(size: 12))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }

                    Spacer()
                }
            }
            .fhCard()

            // Recent Activity
            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("RECENT ACTIVITY")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                VStack(spacing: 0) {
                    activityRow(icon: "checkmark.circle.fill", text: "Completed Upper Body Strength", time: "2h ago", color: FH.Colors.success)
                    Divider().background(FH.Colors.border)
                    activityRow(icon: "message.fill", text: "Sent check-in reminder", time: "5h ago", color: FH.Colors.accent)
                    Divider().background(FH.Colors.border)
                    activityRow(icon: "dollarsign.circle.fill", text: "Paid $320 for April", time: "1d ago", color: FH.Colors.primary)
                }
            }
            .fhCard()
        }
    }

    private func goalRow(icon: String, text: String) -> some View {
        HStack(spacing: FH.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(FH.Colors.primary)
                .frame(width: 20)
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(FH.Colors.text)
        }
    }

    private func activityRow(icon: String, text: String, time: String, color: Color) -> some View {
        HStack(spacing: FH.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(color)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.text)
                Text(time)
                    .font(.system(size: 12))
                    .foregroundStyle(FH.Colors.textSubtle)
            }

            Spacer()
        }
        .padding(.vertical, FH.Spacing.sm)
    }

    // MARK: - Programs Tab

    private var programsTab: some View {
        VStack(spacing: FH.Spacing.xl) {
            VStack(spacing: FH.Spacing.md) {
                Text("ACTIVE PROGRAM")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                    Text("12-Week Strength Builder")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                    Text("Week 3 of 12 · Push/Pull/Legs split")
                        .font(.system(size: 14))
                        .foregroundStyle(FH.Colors.textMuted)

                    HStack(spacing: FH.Spacing.sm) {
                        statPill("3 days/week")
                        statPill("45–60 min")
                    }
                }

                Button {
                    // Assign new program
                } label: {
                    HStack {
                        Image(systemName: "arrow.2.squarepath")
                        Text("Change Program")
                    }
                }
                .buttonStyle(FHSecondaryButtonStyle())
            }
            .fhCard()

            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("PROGRAM HISTORY")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                VStack(spacing: 0) {
                    historyRow(name: "Foundation Phase", dates: "Jan 15 – Mar 15", status: "Completed")
                    Divider().background(FH.Colors.border)
                    historyRow(name: "Hypertrophy Block", dates: "Nov 1 – Jan 14", status: "Completed")
                }
            }
            .fhCard()
        }
    }

    private func historyRow(name: String, dates: String, status: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                Text(dates)
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            Spacer()
            Text(status)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(FH.Colors.success)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(FH.Colors.success.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(.vertical, FH.Spacing.sm)
    }

    // MARK: - Progress Tab

    private var progressTab: some View {
        VStack(spacing: FH.Spacing.xl) {
            HStack(spacing: FH.Spacing.sm) {
                statTile(value: "79.8", label: "Current kg", icon: "scalemass.fill")
                statTile(value: "82.3", label: "Start kg", icon: "arrow.counterclockwise")
                statTile(value: "−2.5", label: "Change", icon: "arrow.down", accent: true)
            }

            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("BODY MEASUREMENTS")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                VStack(spacing: 0) {
                    measurementRow(name: "Chest", value: "98.5", unit: "cm", change: "−0.7")
                    Divider().background(FH.Colors.border)
                    measurementRow(name: "Waist", value: "82.0", unit: "cm", change: "−2.5")
                    Divider().background(FH.Colors.border)
                    measurementRow(name: "Hips", value: "96.0", unit: "cm", change: "−0.8")
                    Divider().background(FH.Colors.border)
                    measurementRow(name: "Left Arm", value: "36.5", unit: "cm", change: "+0.7")
                }
            }
            .fhCard()

            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("PERSONAL RECORDS")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                VStack(spacing: FH.Spacing.sm) {
                    prRow(exercise: "Bench Press", value: "100 kg", date: "3 days ago")
                    prRow(exercise: "Back Squat", value: "140 kg", date: "10 days ago")
                    prRow(exercise: "Deadlift", value: "180 kg", date: "14 days ago")
                }
            }
            .fhCard()
        }
    }

    private func measurementRow(name: String, value: String, unit: String, change: String) -> some View {
        HStack {
            Text(name)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(FH.Colors.text)
            Spacer()
            Text("\(value) \(unit)")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(FH.Colors.text)
                .monospacedDigit()
            Text(change)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(change.hasPrefix("−") ? FH.Colors.success : (change.hasPrefix("+") ? FH.Colors.warning : FH.Colors.textSubtle))
                .frame(width: 50, alignment: .trailing)
                .monospacedDigit()
        }
        .padding(.vertical, FH.Spacing.sm)
    }

    private func prRow(exercise: String, value: String, date: String) -> some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(FH.Colors.warning.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: "trophy.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(FH.Colors.warning)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(exercise)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                Text(date)
                    .font(.system(size: 12))
                    .foregroundStyle(FH.Colors.textSubtle)
            }

            Spacer()

            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(FH.Colors.primary)
                .monospacedDigit()
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
    }

    // MARK: - Notes Tab

    private var notesTab: some View {
        VStack(spacing: FH.Spacing.xl) {
            Button {
                // Add note
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Session Note")
                }
            }
            .buttonStyle(FHPrimaryButtonStyle())

            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("RECENT NOTES")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                VStack(spacing: FH.Spacing.sm) {
                    noteCard(date: "Apr 20", text: "Great energy today. Pushed weight up on bench and handled it well. Keep protein high this week.")
                    noteCard(date: "Apr 18", text: "Mentioned left shoulder tightness during warm-up. Monitored throughout session, no pain at working weight. Recommend foam rolling before next push day.")
                    noteCard(date: "Apr 15", text: "Check-in call: down 0.8 kg, sleep improving, stress lower. Nutrition adherence at 90%.")
                }
            }
        }
    }

    private func noteCard(date: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            Text(date)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.primary)
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(FH.Colors.text)
                .lineSpacing(3)
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
    }

    // MARK: - Helpers

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

    private func statPill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(FH.Colors.textMuted)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(FH.Colors.surface2)
            .clipShape(Capsule())
    }
}

// MARK: - Extension

extension ClientItem {
    var firstName: String {
        name.components(separatedBy: " ").first ?? name
    }
}

#Preview {
    ClientDetailView(
        client: ClientItem(
            name: "Alex Johnson",
            plan: "Pro — 3×/week",
            status: "Active",
            lastActive: "2h ago",
            initials: "AJ"
        )
    )
    .preferredColorScheme(.dark)
}
