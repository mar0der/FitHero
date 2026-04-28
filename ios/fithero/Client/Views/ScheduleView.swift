import SwiftUI

struct ScheduleView: View {
    let sessions = SampleData.upcomingSessions
    @State private var selectedSession: TrainingSession? = nil
    @State private var showCalendarAlert = false
    @State private var calendarAlertTitle = ""
    @State private var calendarAlertMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(spacing: FH.Spacing.lg) {
                    ForEach(sessions) { session in
                        sessionCard(session)
                            .onTapGesture {
                                selectedSession = session
                            }
                    }

                    pastSessionsSection
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xxxl)
            }
        }
        .background(FH.Colors.bg)
        .sheet(item: $selectedSession) { session in
            SessionDetailSheet(session: session)
        }
        .alert(calendarAlertTitle, isPresented: $showCalendarAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(calendarAlertMessage)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: FH.Spacing.xs) {
                Text("Schedule")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                Text("Upcoming sessions")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            Spacer()
        }
        .padding(.horizontal, FH.Spacing.base)
        .padding(.top, FH.Spacing.lg)
        .padding(.bottom, FH.Spacing.lg)
    }

    // MARK: - Session Card

    private func sessionCard(_ session: TrainingSession) -> some View {
        let iconColor = sessionIconColor(session.type)
        let isNext = session.id == sessions.first?.id

        return HStack(spacing: FH.Spacing.base) {
            // Date column
            VStack(spacing: 2) {
                Text(session.date.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(0.5)
                Text(session.date.formatted(.dateTime.day()))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(isNext ? FH.Colors.primary : FH.Colors.text)
                    .monospacedDigit()
                Text(session.date.formatted(.dateTime.month(.abbreviated)))
                    .font(.system(size: 12))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            .frame(width: 50)

            // Divider line
            Rectangle()
                .fill(isNext ? FH.Colors.primary : FH.Colors.border)
                .frame(width: 2)
                .clipShape(RoundedRectangle(cornerRadius: 1))

            // Content
            VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                HStack(spacing: FH.Spacing.sm) {
                    ZStack {
                        RoundedRectangle(cornerRadius: FH.Radius.sm)
                            .fill(iconColor.opacity(0.15))
                            .frame(width: 32, height: 32)
                        Image(systemName: session.type.icon)
                            .font(.system(size: 14))
                            .foregroundStyle(iconColor)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.type.rawValue)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(FH.Colors.text)
                        Text("with \(session.trainerName)")
                            .font(.system(size: 13))
                            .foregroundStyle(FH.Colors.textMuted)
                    }
                }

                HStack(spacing: FH.Spacing.base) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                        Text(session.date.formatted(.dateTime.hour().minute()))
                            .font(.system(size: 13))
                    }
                    .foregroundStyle(FH.Colors.textMuted)

                    HStack(spacing: 4) {
                        Image(systemName: "timer")
                            .font(.system(size: 11))
                        Text("\(session.durationMinutes) min")
                            .font(.system(size: 13))
                    }
                    .foregroundStyle(FH.Colors.textMuted)
                }

                if let loc = session.location {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 11))
                        Text(loc)
                            .font(.system(size: 13))
                    }
                    .foregroundStyle(FH.Colors.textSubtle)
                }

                if isNext {
                    HStack(spacing: FH.Spacing.sm) {
                        Button {
                            addToCalendar(session)
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.system(size: 12))
                                Text("Add to Calendar")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .foregroundStyle(FH.Colors.primary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(FH.Colors.primary.opacity(0.1))
                            .clipShape(Capsule())
                        }

                        Button {
                            selectedSession = session
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 12))
                                Text("Reschedule")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .foregroundStyle(FH.Colors.textMuted)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(FH.Colors.surface2)
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.top, FH.Spacing.xs)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(FH.Spacing.base)
        .background(isNext ? FH.Colors.surface : FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(isNext ? FH.Colors.primary.opacity(0.3) : FH.Colors.border, lineWidth: 1)
        )
    }

    private func addToCalendar(_ session: TrainingSession) {
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
                calendarAlertMessage = "Your \(session.type.rawValue.lowercased()) session has been added."
            case .failure(let error):
                calendarAlertTitle = "Couldn't Add"
                calendarAlertMessage = error.localizedDescription
            }
            showCalendarAlert = true
        }
    }

    private func sessionIconColor(_ type: TrainingSession.SessionType) -> Color {
        switch type {
        case .inPerson: FH.Colors.accent
        case .video: FH.Colors.primary
        case .checkIn: FH.Colors.success
        }
    }

    // MARK: - Past Sessions

    private var pastSessionsSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("PAST SESSIONS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            ForEach(0..<3, id: \.self) { i in
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("In-person with Maya")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(FH.Colors.textMuted)
                        Text("\(3 + i * 4) days ago")
                            .font(.system(size: 12))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(FH.Colors.success)
                        .font(.system(size: 18))
                }
                .padding(.vertical, FH.Spacing.sm)
                if i < 2 {
                    Divider().background(FH.Colors.border)
                }
            }
        }
        .fhCard()
    }
}

#Preview {
    ScheduleView()
        .preferredColorScheme(.dark)
}
