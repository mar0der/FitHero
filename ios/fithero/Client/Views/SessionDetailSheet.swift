import SwiftUI

struct SessionDetailSheet: View {
    let session: TrainingSession
    @Environment(\.dismiss) private var dismiss
    @State private var showReschedule = false
    @State private var showCalendarAlert = false
    @State private var calendarAlertTitle = ""
    @State private var calendarAlertMessage = ""

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: FH.Spacing.xl) {
                        dateHeader
                        infoCard
                        actionsCard
                    }
                    .padding(FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .navigationTitle("Session Details")
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
            .sheet(isPresented: $showReschedule) {
                RescheduleSheet(session: session)
            }
            .alert(calendarAlertTitle, isPresented: $showCalendarAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(calendarAlertMessage)
            }
        }
    }

    private var dateHeader: some View {
        VStack(spacing: FH.Spacing.md) {
            Text(session.date.formatted(.dateTime.weekday(.wide)))
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(FH.Colors.textMuted)
                .tracking(0.5)

            Text(session.date.formatted(.dateTime.day()))
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(FH.Colors.text)
                .monospacedDigit()

            Text(session.date.formatted(.dateTime.month(.wide).year()))
                .font(.system(size: 16))
                .foregroundStyle(FH.Colors.textMuted)

            Text(session.date.formatted(.dateTime.hour().minute()))
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(FH.Colors.primary)
                .monospacedDigit()
                .padding(.top, FH.Spacing.sm)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FH.Spacing.xl)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
    }

    private var infoCard: some View {
        VStack(spacing: FH.Spacing.md) {
            detailRow(icon: session.type.icon, iconColor: sessionIconColor(session.type), title: "Type", value: session.type.rawValue)
            Divider().background(FH.Colors.border)
            detailRow(icon: "person.fill", iconColor: FH.Colors.accent, title: "Trainer", value: session.trainerName)
            Divider().background(FH.Colors.border)
            detailRow(icon: "timer", iconColor: FH.Colors.warning, title: "Duration", value: "\(session.durationMinutes) minutes")
            if let loc = session.location {
                Divider().background(FH.Colors.border)
                detailRow(icon: "mappin", iconColor: FH.Colors.success, title: "Location", value: loc)
            }
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
    }

    private var actionsCard: some View {
        VStack(spacing: FH.Spacing.md) {
            Button {
                addToCalendar()
            } label: {
                HStack(spacing: FH.Spacing.sm) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 16))
                    Text("Add to Calendar")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 14))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
                .foregroundStyle(FH.Colors.primary)
                .padding(.horizontal, FH.Spacing.base)
                .padding(.vertical, 14)
                .background(FH.Colors.primary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            }

            Button {
                showReschedule = true
            } label: {
                HStack(spacing: FH.Spacing.sm) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 16))
                    Text("Reschedule")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
                .foregroundStyle(FH.Colors.text)
                .padding(.horizontal, FH.Spacing.base)
                .padding(.vertical, 14)
                .background(FH.Colors.surface2)
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            }
        }
    }

    private func detailRow(icon: String, iconColor: Color, title: String, value: String) -> some View {
        HStack(spacing: FH.Spacing.base) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.sm)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundStyle(FH.Colors.textSubtle)
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
            }

            Spacer()
        }
    }

    private func addToCalendar() {
        FHHaptics.medium()
        CalendarHelper.addSessionToCalendar(
            title: "\(session.type.rawValue) with \(session.trainerName)",
            startDate: session.date,
            durationMinutes: session.durationMinutes,
            location: session.location
        ) { result in
            switch result {
            case .success:
                calendarAlertTitle = "Added to Calendar"
                calendarAlertMessage = "Your session has been added to your calendar."
            case .failure(let error):
                calendarAlertTitle = "Couldn't Add"
                calendarAlertMessage = error.localizedDescription
            }
            showCalendarAlert = true
        }
    }

    private func sessionIconColor(_ type: TrainingSession.SessionType) -> Color {
        switch type {
        case .inPerson: return FH.Colors.accent
        case .video: return FH.Colors.primary
        case .checkIn: return FH.Colors.success
        }
    }
}
