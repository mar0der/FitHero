import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.dismiss) private var dismiss
    @State private var selectedExercise: Exercise? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: FH.Spacing.xl) {
                        headerCard
                        exerciseList
                    }
                    .padding(FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .navigationTitle("Workout Details")
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
            .sheet(item: $selectedExercise) { exercise in
                ExerciseDetailView(exercise: exercise, showClientData: false)
            }
        }
    }

    // MARK: - Header Card

    private var headerCard: some View {
        VStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .fill(FH.Colors.primary.opacity(0.12))
                    .frame(width: 72, height: 72)
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(FH.Colors.primary)
            }

            Text(workout.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(FH.Colors.text)
                .multilineTextAlignment(.center)

            Text(workout.category.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.primary)
                .tracking(1.2)

            HStack(spacing: FH.Spacing.md) {
                HStack(spacing: 4) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 12))
                    Text("\(workout.exercises.count) exercises")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(FH.Colors.textMuted)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text("\(workout.estimatedMinutes) min")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(FH.Colors.textMuted)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(FH.Spacing.lg)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
    }

    // MARK: - Exercise List

    private var exerciseList: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: "list.bullet.rectangle.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.primary)
                Text("EXERCISES")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
                Spacer()
                Text("\(workout.exercises.count)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            VStack(spacing: FH.Spacing.sm) {
                ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                    exerciseRow(exercise, index: index)
                }
            }
        }
    }

    private func exerciseRow(_ exercise: Exercise, index: Int) -> some View {
        Button {
            FHHaptics.selection()
            selectedExercise = exercise
        } label: {
            HStack(spacing: FH.Spacing.md) {
                // Number badge
                ZStack {
                    RoundedRectangle(cornerRadius: FH.Radius.md)
                        .fill(FH.Colors.primary.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Text("\(index + 1)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(FH.Colors.primary)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(exercise.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(FH.Colors.text)

                    HStack(spacing: 8) {
                        Text("\(exercise.targetSets)×\(exercise.targetReps)")
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundStyle(FH.Colors.textMuted)
                        Text("·")
                            .foregroundStyle(FH.Colors.textSubtle)
                        Text("\(exercise.restSeconds)s rest")
                            .font(.system(size: 12))
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
}

#Preview {
    WorkoutDetailView(workout: SampleData.workoutLibrary[0])
        .preferredColorScheme(.dark)
}
