import SwiftUI

// MARK: - Model

struct TodaySession: Identifiable {
    let id = UUID()
    var clientName: String
    var time: String
    var type: SessionLabel
    var durationMinutes: Int
    var location: String?
    var isCompleted: Bool = false
    var isNext: Bool = false

    enum SessionLabel: String {
        case inPerson = "In-person"
        case video = "Video call"
        case checkIn = "Check-in"

        var icon: String {
            switch self {
            case .inPerson: "figure.walk"
            case .video: "video.fill"
            case .checkIn: "checkmark.message.fill"
            }
        }

        var color: Color {
            switch self {
            case .inPerson: FH.Colors.accent
            case .video: FH.Colors.primary
            case .checkIn: FH.Colors.success
            }
        }
    }
}

// MARK: - View

struct TodayView: View {
    @State private var showNotifications = false
    @State private var showRescheduleSheet = false
    @State private var showCancelAlert = false
    @State private var sessionToReschedule: TodaySession?
    @State private var sessionToCancel: TodaySession?
    @State private var showMarkAllConfirmation = false
    let unreadCount = 3

    @State private var sessions: [TodaySession] = [
        TodaySession(clientName: "Alex Johnson", time: "09:00", type: .inPerson, durationMinutes: 60, location: "FitStudio Downtown", isCompleted: false, isNext: true),
        TodaySession(clientName: "Marco Rossi", time: "11:30", type: .video, durationMinutes: 30, location: nil, isCompleted: false, isNext: false),
        TodaySession(clientName: "Erika Szabo", time: "16:00", type: .checkIn, durationMinutes: 15, location: nil, isCompleted: false, isNext: false),
    ]

    private var incompleteSessions: [TodaySession] {
        sessions.filter { !$0.isCompleted }
    }

    private var completedSessions: [TodaySession] {
        sessions.filter { $0.isCompleted }
    }

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
        .sheet(item: $sessionToReschedule) { session in
            RescheduleSessionSheet(session: session) { newTime in
                rescheduleSession(id: session.id, to: newTime)
            }
        }
        .alert("Cancel Session?", isPresented: $showCancelAlert, presenting: sessionToCancel) { session in
            Button("Cancel Session", role: .destructive) {
                cancelSession(id: session.id)
            }
            Button("Keep Session", role: .cancel) { }
        } message: { session in
            Text("This will cancel your \(session.type.rawValue.lowercased()) with \(session.clientName) at \(session.time).")
        }
        .alert("Mark all complete?", isPresented: $showMarkAllConfirmation) {
            Button("Mark All Complete", role: .none) {
                markAllComplete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will mark all \(incompleteSessions.count) remaining sessions as completed.")
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

                if !incompleteSessions.isEmpty {
                    Button {
                        showMarkAllConfirmation = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 11))
                            Text("Mark all")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(FH.Colors.success)
                    }
                    .buttonStyle(.plain)
                }

                Text(sessionCountText)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            if incompleteSessions.isEmpty {
                emptyState
            } else {
                VStack(spacing: FH.Spacing.sm) {
                    ForEach($sessions) { $session in
                        if !session.isCompleted {
                            sessionRow(session: $session)
                        }
                    }
                }
            }

            if !completedSessions.isEmpty {
                completedSection
            }
        }
        .fhCard()
    }

    private var sessionCountText: String {
        let total = sessions.count
        let done = completedSessions.count
        if total == 0 { return "None scheduled" }
        if done == total { return "All done" }
        return "\(total - done) of \(total)"
    }

    private var emptyState: some View {
        VStack(spacing: FH.Spacing.md) {
            ZStack {
                Circle()
                    .fill(FH.Colors.success.opacity(0.1))
                    .frame(width: 64, height: 64)
                Image(systemName: "calendar.badge.checkmark")
                    .font(.system(size: 28))
                    .foregroundStyle(FH.Colors.success)
            }

            VStack(spacing: FH.Spacing.xs) {
                Text("All caught up!")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                Text("You have no pending sessions for today.")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FH.Spacing.xl)
    }

    private var completedSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            Text("COMPLETED")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1)
                .padding(.top, FH.Spacing.sm)

            VStack(spacing: FH.Spacing.sm) {
                ForEach($sessions) { $session in
                    if session.isCompleted {
                        sessionRow(session: $session)
                    }
                }
            }
        }
    }

    private func sessionRow(session: Binding<TodaySession>) -> some View {
        let s = session.wrappedValue
        return HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(s.type.color.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: s.type.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(s.type.color)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(s.clientName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                HStack(spacing: FH.Spacing.xs) {
                    Text(s.time)
                    Text("·")
                    Text(s.type.rawValue)
                    Text("·")
                    Text("\(s.durationMinutes) min")
                }
                .font(.system(size: 13))
                .foregroundStyle(FH.Colors.textMuted)
                if let loc = s.location {
                    Text(loc)
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
            }

            Spacer(minLength: 0)

            if s.isNext && !s.isCompleted {
                Text("Next")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(FH.Colors.primaryInk)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(FH.Colors.primary)
                    .clipShape(Capsule())
            } else if s.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(FH.Colors.success)
            }
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(s.isNext && !s.isCompleted ? FH.Colors.primary.opacity(0.35) : FH.Colors.border, lineWidth: 1)
        )
        .opacity(s.isCompleted ? 0.65 : 1)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if !s.isCompleted {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        completeSession(id: s.id)
                    }
                } label: {
                    Label("Complete", systemImage: "checkmark.circle.fill")
                }
                .tint(FH.Colors.success)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if !s.isCompleted {
                Button {
                    sessionToReschedule = s
                } label: {
                    Label("Reschedule", systemImage: "calendar.badge.clock")
                }
                .tint(FH.Colors.accent)

                Button {
                    sessionToCancel = s
                    showCancelAlert = true
                } label: {
                    Label("Cancel", systemImage: "xmark.circle.fill")
                }
                .tint(FH.Colors.danger)
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        uncompleteSession(id: s.id)
                    }
                } label: {
                    Label("Undo", systemImage: "arrow.uturn.backward.circle.fill")
                }
                .tint(FH.Colors.textMuted)
            }
        }
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
                statTile(value: "\(incompleteSessions.count)", label: "Remaining", icon: "calendar", accent: true)
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

    // MARK: - Actions

    private func completeSession(id: UUID) {
        if let index = sessions.firstIndex(where: { $0.id == id }) {
            sessions[index].isCompleted = true
            sessions[index].isNext = false
            promoteNextSession()
        }
    }

    private func uncompleteSession(id: UUID) {
        if let index = sessions.firstIndex(where: { $0.id == id }) {
            sessions[index].isCompleted = false
            promoteNextSession()
        }
    }

    private func cancelSession(id: UUID) {
        withAnimation(.easeInOut(duration: 0.25)) {
            sessions.removeAll { $0.id == id }
            promoteNextSession()
        }
    }

    private func rescheduleSession(id: UUID, to newTime: String) {
        if let index = sessions.firstIndex(where: { $0.id == id }) {
            sessions[index].time = newTime
        }
    }

    private func markAllComplete() {
        withAnimation(.easeInOut(duration: 0.3)) {
            for index in sessions.indices {
                sessions[index].isCompleted = true
                sessions[index].isNext = false
            }
        }
    }

    private func promoteNextSession() {
        let incomplete = sessions.filter { !$0.isCompleted }
        guard !incomplete.isEmpty else { return }
        if let firstIndex = sessions.firstIndex(where: { !$0.isCompleted }) {
            for i in sessions.indices {
                sessions[i].isNext = (i == firstIndex)
            }
        }
    }

    // MARK: - Helpers

    private var dateString: String {
        Date().formatted(.dateTime.weekday(.wide).month(.wide).day())
    }
}

// MARK: - Reschedule Sheet

struct RescheduleSessionSheet: View {
    let session: TodaySession
    let onConfirm: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var selectedHour = 9
    @State private var selectedMinute = 0

    private var timeString: String {
        String(format: "%02d:%02d", selectedHour, selectedMinute)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                VStack(spacing: FH.Spacing.xl) {
                    VStack(spacing: FH.Spacing.md) {
                        Text("Reschedule")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(FH.Colors.text)

                        Text("Pick a new time for your \(session.type.rawValue.lowercased()) with \(session.clientName).")
                            .font(.system(size: 15))
                            .foregroundStyle(FH.Colors.textMuted)
                            .multilineTextAlignment(.center)
                    }

                    HStack(spacing: FH.Spacing.lg) {
                        VStack {
                            Text("Hour")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(FH.Colors.textSubtle)
                            Picker("Hour", selection: $selectedHour) {
                                ForEach(6...21, id: \.self) { hour in
                                    Text("\(hour)").tag(hour)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 80, height: 140)
                            .clipped()
                        }

                        Text(":")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(FH.Colors.text)

                        VStack {
                            Text("Minute")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(FH.Colors.textSubtle)
                            Picker("Minute", selection: $selectedMinute) {
                                ForEach([0, 15, 30, 45], id: \.self) { minute in
                                    Text(String(format: "%02d", minute)).tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 80, height: 140)
                            .clipped()
                        }
                    }

                    Spacer()

                    Button {
                        onConfirm(timeString)
                        dismiss()
                    } label: {
                        Text("Confirm \(timeString)")
                    }
                    .buttonStyle(FHPrimaryButtonStyle())
                }
                .padding(FH.Spacing.base)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(FH.Colors.textMuted)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TodayView()
        .preferredColorScheme(.dark)
}
