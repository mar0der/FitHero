import SwiftUI

struct EditWorkoutSheet: View {
    let workout: Workout
    let onSave: (Workout) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var category: String
    @State private var duration: String
    @State private var exercises: [Exercise]
    @State private var showExercisePicker = false

    init(workout: Workout, onSave: @escaping (Workout) -> Void) {
        self.workout = workout
        self.onSave = onSave
        _name = State(initialValue: workout.name)
        _category = State(initialValue: workout.category)
        _duration = State(initialValue: String(workout.estimatedMinutes))
        _exercises = State(initialValue: workout.exercises)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: FH.Spacing.xl) {
                        fieldsSection
                        exerciseSection
                    }
                    .padding(FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .navigationTitle("Edit Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(FH.Colors.textMuted)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        save()
                    }
                    .foregroundStyle(hasChanges ? FH.Colors.primary : FH.Colors.textSubtle)
                    .disabled(!hasChanges)
                }
            }
            .sheet(isPresented: $showExercisePicker) {
                ExercisePickerSheet(selectedExercises: $exercises)
            }
        }
    }

    private var hasChanges: Bool {
        name != workout.name
        || category != workout.category
        || duration != String(workout.estimatedMinutes)
        || exercises.count != workout.exercises.count
        || exercises.map(\.id) != workout.exercises.map(\.id)
    }

    // MARK: - Fields

    private var fieldsSection: some View {
        VStack(spacing: FH.Spacing.lg) {
            editField(label: "Workout Name", text: $name, placeholder: "e.g. Upper Body Power")
            editField(label: "Category", text: $category, placeholder: "e.g. Push / Pull / Legs")
            editField(label: "Duration (min)", text: $duration, placeholder: "45", keyboard: .numberPad)
        }
    }

    private func editField(label: String, text: Binding<String>, placeholder: String, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            Text(label.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)
            TextField(placeholder, text: text)
                .font(.system(size: 15))
                .foregroundStyle(FH.Colors.text)
                .padding(.horizontal, FH.Spacing.md)
                .padding(.vertical, FH.Spacing.sm)
                .background(FH.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: FH.Radius.md)
                        .stroke(FH.Colors.border, lineWidth: 1)
                )
                .keyboardType(keyboard)
        }
    }

    // MARK: - Exercise List

    private var exerciseSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack {
                Text("EXERCISES")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
                Spacer()
                Text("\(exercises.count)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            List {
                ForEach(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                    exerciseEditRow(exercise, index: index)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                }
                .onMove(perform: moveExercise)
                .onDelete(perform: deleteExercise)

                Button {
                    FHHaptics.medium()
                    showExercisePicker = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18))
                        Text("Add Exercise")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundStyle(FH.Colors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, FH.Spacing.md)
                    .background(FH.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                    .overlay(
                        RoundedRectangle(cornerRadius: FH.Radius.lg)
                            .stroke(FH.Colors.primary.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            }
            .listStyle(.plain)
            .scrollDisabled(true)
            .background(Color.clear)
        }
    }

    private func exerciseEditRow(_ exercise: Exercise, index: Int) -> some View {
        HStack(spacing: FH.Spacing.md) {
            // Drag handle
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 14))
                .foregroundStyle(FH.Colors.textSubtle)

            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(FH.Colors.primary.opacity(0.1))
                    .frame(width: 36, height: 36)
                Text("\(index + 1)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(FH.Colors.primary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                Text("\(exercise.targetSets)×\(exercise.targetReps) · \(exercise.restSeconds)s rest")
                    .font(.system(size: 12))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            Spacer(minLength: 0)
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
    }

    private func moveExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
    }

    private func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }

    private func save() {
        let updated = Workout(
            id: workout.id,
            name: name,
            category: category,
            estimatedMinutes: Int(duration) ?? workout.estimatedMinutes,
            exercises: exercises
        )
        FHHaptics.success()
        onSave(updated)
        dismiss()
    }
}

#Preview {
    EditWorkoutSheet(workout: SampleData.workoutLibrary[0]) { _ in }
        .preferredColorScheme(.dark)
}
