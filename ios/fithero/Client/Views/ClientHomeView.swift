import SwiftUI

struct ClientHomeView: View {
    let workout = SampleData.todayWorkout
    let sessions = SampleData.upcomingSessions
    let weekActivity = SampleData.weekActivity
    let onSignOut: () -> Void

    @State private var showWorkout = false
    @State private var showProfile = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FH.Spacing.xl) {
                greetingSection
                todayWorkoutCard
                weeklyActivityCard
                nextSessionCard
                messagePreviewCard
            }
            .padding(.horizontal, FH.Spacing.base)
            .padding(.bottom, FH.Spacing.xxxl)
        }
        .background(FH.Colors.bg)
        .fullScreenCover(isPresented: $showWorkout) {
            WorkoutFlowView(workout: workout, onDismiss: { showWorkout = false })
                .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showProfile) {
            ProfileSheet(onSignOut: onSignOut)
        }
    }

    // MARK: - Greeting

    private var greetingSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: FH.Spacing.xs) {
                Text(greetingText)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                Text(dateString)
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            Spacer()
            Button {
                showProfile = true
            } label: {
                ZStack {
                    Circle()
                        .fill(FH.Colors.primary.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Text(SampleData.clientAvatar)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(FH.Colors.primary)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.top, FH.Spacing.lg)
    }

    // MARK: - Today's Workout Card

    private var todayWorkoutCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.base) {
            HStack {
                Text("TODAY'S WORKOUT")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.primary)
                    .tracking(1.2)
                Spacer()
                Text("\(workout.estimatedMinutes) min")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                Text(workout.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                Text("\(workout.exercises.count) exercises  ·  \(workout.category)")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            // Exercise preview pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: FH.Spacing.sm) {
                    ForEach(workout.exercises) { exercise in
                        HStack(spacing: 6) {
                            Image(systemName: exercise.sfSymbol)
                                .font(.system(size: 11))
                            Text(exercise.name)
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(FH.Colors.textMuted)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(FH.Colors.surface2)
                        .clipShape(Capsule())
                    }
                }
            }

            Button {
                showWorkout = true
            } label: {
                HStack {
                    Text("Start Workout")
                    Image(systemName: "arrow.right")
                }
            }
            .buttonStyle(FHPrimaryButtonStyle())
        }
        .fhCard()
    }

    // MARK: - Weekly Activity

    private var weeklyActivityCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack {
                Text("THIS WEEK")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
                Spacer()
                Text("3 of 5 workouts")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            HStack(spacing: 0) {
                ForEach(Array(dayLabels.enumerated()), id: \.offset) { index, day in
                    VStack(spacing: FH.Spacing.sm) {
                        Text(day)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(FH.Colors.textSubtle)
                        activityDot(for: weekActivity[index])
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .fhCard()
    }

    private func activityDot(for status: Bool?) -> some View {
        ZStack {
            Circle()
                .fill(dotColor(for: status))
                .frame(width: 28, height: 28)
            if status == true {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(FH.Colors.primaryInk)
            } else if status == false {
                Circle()
                    .fill(FH.Colors.primary.opacity(0.4))
                    .frame(width: 10, height: 10)
            }
        }
    }

    private func dotColor(for status: Bool?) -> Color {
        switch status {
        case true: FH.Colors.primary
        case false: FH.Colors.surface2
        case nil: FH.Colors.surface2
        }
    }

    // MARK: - Next Session

    private var nextSessionCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("NEXT SESSION")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            if let next = sessions.first {
                HStack(spacing: FH.Spacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: FH.Radius.md)
                            .fill(FH.Colors.accent.opacity(0.15))
                            .frame(width: 44, height: 44)
                        Image(systemName: next.type.icon)
                            .font(.system(size: 18))
                            .foregroundStyle(FH.Colors.accent)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(next.type.rawValue) with \(next.trainerName)")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(FH.Colors.text)
                        HStack(spacing: FH.Spacing.xs) {
                            Text(next.date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()))
                                .font(.system(size: 13))
                            Text("·")
                            Text(next.date.formatted(.dateTime.hour().minute()))
                                .font(.system(size: 13))
                        }
                        .foregroundStyle(FH.Colors.textMuted)
                        if let loc = next.location {
                            Text(loc)
                                .font(.system(size: 12))
                                .foregroundStyle(FH.Colors.textSubtle)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
            }
        }
        .fhCard()
    }

    // MARK: - Message Preview

    private var messagePreviewCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack {
                Text("MESSAGES")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
                Spacer()
                ZStack {
                    Circle()
                        .fill(FH.Colors.primary)
                        .frame(width: 20, height: 20)
                    Text("1")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(FH.Colors.primaryInk)
                }
            }

            if let latest = SampleData.messages.last {
                HStack(spacing: FH.Spacing.md) {
                    ZStack {
                        Circle()
                            .fill(FH.Colors.accent.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Text(SampleData.trainerAvatar)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(FH.Colors.accent)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(latest.senderName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(FH.Colors.text)
                        Text(latest.text)
                            .font(.system(size: 13))
                            .foregroundStyle(FH.Colors.textMuted)
                            .lineLimit(2)
                    }

                    Spacer(minLength: 0)

                    Text("5m")
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
            }
        }
        .fhCard()
    }

    // MARK: - Helpers

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let name = SampleData.clientName
        if hour < 12 { return "Good morning, \(name)" }
        if hour < 17 { return "Good afternoon, \(name)" }
        return "Good evening, \(name)"
    }

    private var dateString: String {
        Date().formatted(.dateTime.weekday(.wide).month(.wide).day())
    }

    private let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]
}

#Preview {
    ClientHomeView(onSignOut: {})
        .preferredColorScheme(.dark)
}
