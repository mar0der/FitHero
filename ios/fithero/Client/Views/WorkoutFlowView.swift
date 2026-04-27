import SwiftUI

/// Owns the full workout lifecycle: Read → Active (any exercise) → back to Read → Summary
struct WorkoutFlowView: View {
    let workout: Workout
    var onDismiss: (() -> Void)? = nil

    enum Phase {
        case read
        case active(exerciseIndex: Int)
        case summary(durationSeconds: Int)
    }

    @State private var phase: Phase = .read
    @State private var completedExercises: Set<Int> = []
    @State private var totalElapsed: Int = 0

    private var nextIncompleteIndex: Int {
        (0..<workout.exercises.count).first { !completedExercises.contains($0) } ?? 0
    }

    var body: some View {
        switch phase {
        case .read:
            WorkoutReadView(
                workout: workout,
                completedExercises: completedExercises,
                onSelectExercise: { index in
                    phase = .active(exerciseIndex: index)
                },
                onDismiss: { onDismiss?() }
            )

        case .active(let index):
            ActiveWorkoutView(
                workout: workout,
                startingExerciseIndex: index,
                onExerciseDone: { elapsed in
                    totalElapsed += elapsed
                    completedExercises.insert(index)
                    if completedExercises.count == workout.exercises.count {
                        phase = .summary(durationSeconds: totalElapsed)
                    } else {
                        phase = .read
                    }
                },
                onAbandon: {
                    phase = .read
                }
            )

        case .summary(let elapsed):
            WorkoutSummaryView(workout: workout, durationSeconds: elapsed) {
                // Reset and go back to read
                completedExercises = []
                totalElapsed = 0
                phase = .read
            }
        }
    }
}

#Preview {
    WorkoutFlowView(workout: SampleData.todayWorkout)
        .preferredColorScheme(.dark)
}
