import SwiftUI

struct WorkoutReadView: View {
    let workout: Workout
    let completedExercises: Set<Int>
    let onSelectExercise: (Int) -> Void
    let onDismiss: () -> Void

    private var doneCount: Int { completedExercises.count }
    private var totalCount: Int { workout.exercises.count }
    private var progress: Double { Double(doneCount) / Double(totalCount) }
    private var allDone: Bool { doneCount == totalCount }

    private var nextIndex: Int? {
        (0..<totalCount).first { !completedExercises.contains($0) }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    topBar
                    progressHeader
                    exerciseList
                }
                .padding(.bottom, 110)
            }
            .scrollIndicators(.hidden)
            .background(FH.Colors.bg)

            bottomBar
        }
        .background(FH.Colors.bg)
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack {
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
                    .frame(width: 34, height: 34)
                    .background(FH.Colors.surface2)
                    .clipShape(Circle())
            }
            Spacer()
            VStack(spacing: 1) {
                Text(workout.category.uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.4)
                Text("TODAY")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(FH.Colors.primary)
                    .tracking(1.5)
            }
            Spacer()
            // Placeholder to balance the X button
            Color.clear.frame(width: 34, height: 34)
        }
        .padding(.horizontal, FH.Spacing.base)
        .padding(.top, FH.Spacing.lg)
        .padding(.bottom, FH.Spacing.md)
    }

    // MARK: - Progress header

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            // Title + count badge
            HStack(alignment: .firstTextBaseline) {
                Text(workout.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                    .tracking(-0.6)
                Spacer()
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(doneCount)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(doneCount > 0 ? FH.Colors.primary : FH.Colors.textSubtle)
                    Text("/\(totalCount)")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
                .monospacedDigit()
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(FH.Colors.surface2)
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(FH.Colors.primary)
                        .frame(width: geo.size.width * progress, height: 6)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 6)

            // Stats pills
            HStack(spacing: FH.Spacing.sm) {
                statPill(icon: "clock", text: "\(workout.estimatedMinutes) min")
                statPill(icon: "square.stack.3d.up", text: "\(workout.exercises.reduce(0) { $0 + $1.targetSets }) sets total")
                if doneCount > 0 {
                    statPill(icon: "checkmark.circle.fill", text: "\(doneCount) done", accent: true)
                }
            }
        }
        .padding(.horizontal, FH.Spacing.base)
        .padding(.bottom, FH.Spacing.xl)
    }

    private func statPill(icon: String, text: String, accent: Bool = false) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11))
            Text(text)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundStyle(accent ? FH.Colors.primary : FH.Colors.textMuted)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(accent ? FH.Colors.primary.opacity(0.1) : FH.Colors.surface2)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(accent ? FH.Colors.primary.opacity(0.3) : Color.clear, lineWidth: 1))
    }

    // MARK: - Exercise list

    private var exerciseList: some View {
        VStack(spacing: 0) {
            HStack {
                Text("EXERCISES")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
                Spacer()
                Text("Tap any to jump")
                    .font(.system(size: 11))
                    .foregroundStyle(FH.Colors.textSubtle)
            }
            .padding(.horizontal, FH.Spacing.base)
            .padding(.bottom, FH.Spacing.md)

            VStack(spacing: FH.Spacing.sm) {
                ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { i, exercise in
                    exerciseRow(exercise, index: i)
                }
            }
            .padding(.horizontal, FH.Spacing.base)
        }
    }

    private func exerciseRow(_ exercise: Exercise, index: Int) -> some View {
        let isDone = completedExercises.contains(index)
        let isNext = nextIndex == index

        return Button { onSelectExercise(index) } label: {
            HStack(spacing: FH.Spacing.md) {
                // Status icon
                ZStack {
                    RoundedRectangle(cornerRadius: FH.Radius.md)
                        .fill(isDone ? FH.Colors.success.opacity(0.15)
                              : isNext ? FH.Colors.primary.opacity(0.12)
                              : FH.Colors.surface2)
                        .frame(width: 48, height: 48)

                    if isDone {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(FH.Colors.success)
                    } else {
                        Image(systemName: exercise.sfSymbol)
                            .font(.system(size: 20))
                            .foregroundStyle(isNext ? FH.Colors.primary : FH.Colors.textMuted)
                            .symbolRenderingMode(.hierarchical)
                    }
                }

                // Name + chips
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(isDone ? FH.Colors.textSubtle : FH.Colors.text)
                        .strikethrough(isDone, color: FH.Colors.textSubtle)

                    HStack(spacing: 8) {
                        Text("\(exercise.targetSets)×\(exercise.targetReps)")
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundStyle(isDone ? FH.Colors.textSubtle : FH.Colors.textMuted)
                        Text("·")
                            .foregroundStyle(FH.Colors.textSubtle)
                        Text("\(exercise.restSeconds)s rest")
                            .font(.system(size: 12))
                            .foregroundStyle(isDone ? FH.Colors.textSubtle : FH.Colors.textMuted)
                    }
                }

                Spacer(minLength: 0)

                // Right side indicator
                if isDone {
                    Text("Done")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(FH.Colors.success)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(FH.Colors.success.opacity(0.1))
                        .clipShape(Capsule())
                } else if isNext {
                    HStack(spacing: 4) {
                        Text("Next")
                            .font(.system(size: 11, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundStyle(FH.Colors.primaryInk)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(FH.Colors.primary)
                    .clipShape(Capsule())
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
            }
            .padding(FH.Spacing.md)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .stroke(
                        isNext ? FH.Colors.primary.opacity(0.35)
                        : isDone ? FH.Colors.success.opacity(0.2)
                        : FH.Colors.border,
                        lineWidth: 1
                    )
            )
            .opacity(isDone ? 0.75 : 1)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Bottom bar

    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider().background(FH.Colors.border)
            HStack(spacing: FH.Spacing.md) {
                if allDone {
                    // All done — show finish
                    Text("All exercises complete 🎉")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(FH.Colors.textMuted)
                    Spacer()
                } else {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(nextIndex.map { workout.exercises[$0].name } ?? workout.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(FH.Colors.text)
                            .lineLimit(1)
                        Text(doneCount == 0 ? "Start first exercise" : "\(totalCount - doneCount) remaining")
                            .font(.system(size: 12))
                            .foregroundStyle(FH.Colors.textMuted)
                    }
                    Spacer()
                    Button {
                        if let idx = nextIndex { onSelectExercise(idx) }
                    } label: {
                        HStack(spacing: 6) {
                            Text(doneCount == 0 ? "Start" : "Continue")
                                .font(.system(size: 15, weight: .bold))
                            Image(systemName: "play.fill")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(FH.Colors.primaryInk)
                        .padding(.horizontal, 22)
                        .frame(height: 48)
                        .background(FH.Colors.primary)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, FH.Spacing.base)
            .padding(.top, FH.Spacing.md)
            .padding(.bottom, FH.Spacing.xxxl)
            .background(FH.Colors.bg)
        }
    }
}

#Preview {
    WorkoutReadView(
        workout: SampleData.todayWorkout,
        completedExercises: [0, 2],
        onSelectExercise: { _ in },
        onDismiss: {}
    )
    .preferredColorScheme(.dark)
}
