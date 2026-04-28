import SwiftUI

struct WorkoutHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedWorkout: CompletedWorkout? = nil

    private var workouts: [CompletedWorkout] {
        SampleData.completedWorkouts.sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: FH.Spacing.lg) {
                        summaryHeader

                        VStack(spacing: FH.Spacing.sm) {
                            ForEach(workouts) { workout in
                                workoutRow(workout)
                            }
                        }
                    }
                    .padding(FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .navigationTitle("Workout History")
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
            .sheet(item: $selectedWorkout) { workout in
                WorkoutHistoryDetailSheet(workout: workout)
            }
        }
    }

    // MARK: - Summary Header

    private var summaryHeader: some View {
        HStack(spacing: FH.Spacing.lg) {
            statBlock(value: "\(workouts.count)", label: "Total")
            Divider().background(FH.Colors.border)
            statBlock(value: "\(workouts.filter { $0.rpe != nil }.count)", label: "Rated")
            Divider().background(FH.Colors.border)
            statBlock(
                value: String(workouts.compactMap { $0.rpe }.reduce(0, +) / max(workouts.compactMap { $0.rpe }.count, 1)),
                label: "Avg RPE"
            )
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
    }

    private func statBlock(value: some StringProtocol, label: String) -> some View {
        VStack(spacing: 4) {
            Text(String(value))
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(FH.Colors.primary)
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(FH.Colors.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Workout Row

    private func workoutRow(_ workout: CompletedWorkout) -> some View {
        Button {
            FHHaptics.selection()
            selectedWorkout = workout
        } label: {
            HStack(spacing: FH.Spacing.md) {
                // Date column
                VStack(spacing: 2) {
                    Text(workout.date.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(FH.Colors.textSubtle)
                        .tracking(0.5)
                    Text(workout.date.formatted(.dateTime.day()))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(FH.Colors.text)
                        .monospacedDigit()
                    Text(workout.date.formatted(.dateTime.month(.abbreviated)))
                        .font(.system(size: 11))
                        .foregroundStyle(FH.Colors.textMuted)
                }
                .frame(width: 46)

                Rectangle()
                    .fill(FH.Colors.border)
                    .frame(width: 1)

                // Content
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: FH.Spacing.sm) {
                        Text(workout.workoutName)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(FH.Colors.text)
                        Spacer()
                        if let rpe = workout.rpe {
                            Text("RPE \(rpe)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(rpeColor(rpe))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(rpeColor(rpe).opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }

                    HStack(spacing: FH.Spacing.base) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                            Text(workout.durationFormatted)
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(FH.Colors.textMuted)

                        HStack(spacing: 4) {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 10))
                            Text("\(workout.exerciseCount) exercises")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(FH.Colors.textMuted)
                    }
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(FH.Colors.textSubtle)
            }
            .padding(FH.Spacing.md)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func rpeColor(_ rpe: Int) -> Color {
        switch rpe {
        case 1...4: return FH.Colors.success
        case 5...6: return FH.Colors.primary
        case 7...8: return FH.Colors.warning
        default: return FH.Colors.danger
        }
    }
}

// MARK: - Workout History Detail Sheet

struct WorkoutHistoryDetailSheet: View {
    let workout: CompletedWorkout
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: FH.Spacing.xl) {
                        headerCard
                        if let note = workout.notes {
                            notesCard(note)
                        }
                        statsGrid
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
        }
    }

    private var headerCard: some View {
        VStack(spacing: FH.Spacing.md) {
            Text(workout.date.formatted(.dateTime.weekday(.wide)))
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(FH.Colors.textMuted)
                .tracking(0.5)

            Text(workout.date.formatted(.dateTime.day()))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(FH.Colors.text)
                .monospacedDigit()

            Text(workout.date.formatted(.dateTime.month(.wide).year()))
                .font(.system(size: 15))
                .foregroundStyle(FH.Colors.textMuted)

            Text(workout.workoutName)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(FH.Colors.primary)
                .padding(.top, FH.Spacing.sm)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FH.Spacing.xl)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
    }

    private func notesCard(_ note: String) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.accent)
                Text("SESSION NOTES")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
            }
            Text(note)
                .font(.system(size: 14))
                .foregroundStyle(FH.Colors.textMuted)
                .lineSpacing(3)
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
    }

    private var statsGrid: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: FH.Spacing.md) {
            statTile(icon: "clock", label: "Duration", value: workout.durationFormatted)
            statTile(icon: "figure.strengthtraining.traditional", label: "Exercises", value: "\(workout.exerciseCount)")
            statTile(icon: "tag", label: "Category", value: workout.category)
            if let rpe = workout.rpe {
                statTile(icon: "flame", label: "RPE", value: "\(rpe)/10", accent: true)
            }
        }
    }

    private func statTile(icon: String, label: String, value: String, accent: Bool = false) -> some View {
        VStack(spacing: FH.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(accent ? FH.Colors.warning : FH.Colors.primary)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(FH.Colors.text)
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(FH.Colors.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FH.Spacing.lg)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(accent ? FH.Colors.warning.opacity(0.3) : FH.Colors.border, lineWidth: 1)
        )
    }
}

#Preview {
    WorkoutHistoryView()
        .preferredColorScheme(.dark)
}
