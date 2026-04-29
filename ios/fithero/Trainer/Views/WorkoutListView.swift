import SwiftUI

struct WorkoutListView: View {
    @State private var searchText = ""
    @State private var showNewWorkout = false
    @State private var selectedExercise: Exercise? = nil
    @State private var selectedWorkout: Workout? = nil
    @State private var workoutToEdit: Workout? = nil
    @State private var workouts: [Workout] = SampleData.workoutLibrary

    var filteredWorkouts: [Workout] {
        var result = workouts
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                || $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: FH.Spacing.xl) {
                    searchBar
                    workoutList
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xxxl)
            }

            addButton
                .padding(.trailing, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xl)
        }
        .sheet(isPresented: $showNewWorkout) {
            NewWorkoutSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $selectedExercise) { exercise in
            ExerciseDetailView(exercise: exercise, showClientData: false)
        }
        .sheet(item: $selectedWorkout) { workout in
            WorkoutDetailView(workout: workout)
        }
        .sheet(item: $workoutToEdit) { workout in
            EditWorkoutSheet(workout: workout) { updated in
                if let index = workouts.firstIndex(where: { $0.id == updated.id }) {
                    workouts[index] = updated
                }
            }
        }
    }

    // MARK: - Search

    private var searchBar: some View {
        HStack(spacing: FH.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundStyle(FH.Colors.textSubtle)
            TextField("Search workouts", text: $searchText)
                .font(.system(size: 15))
                .foregroundStyle(FH.Colors.text)
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
            }
        }
        .padding(.horizontal, FH.Spacing.md)
        .padding(.vertical, FH.Spacing.sm)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.pill))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.pill)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
    }

    // MARK: - List

    private var workoutList: some View {
        VStack(spacing: FH.Spacing.md) {
            ForEach(filteredWorkouts) { workout in
                workoutCard(workout)
            }

            if filteredWorkouts.isEmpty {
                VStack(spacing: FH.Spacing.md) {
                    Image(systemName: "square.stack.3d.up")
                        .font(.system(size: 32))
                        .foregroundStyle(FH.Colors.textSubtle)
                    Text("No workouts found")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(FH.Colors.textMuted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, FH.Spacing.xxl)
            }
        }
    }

    private func workoutCard(_ workout: Workout) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                    Text(workout.category)
                        .font(.system(size: 13))
                        .foregroundStyle(FH.Colors.textMuted)
                }
                Spacer()
                menuButton(for: workout)
            }

            HStack(spacing: FH.Spacing.sm) {
                statPill(icon: "dumbbell.fill", text: "\(workout.exercises.count) exercises")
                statPill(icon: "clock", text: "\(workout.estimatedMinutes) min")
            }

            // Exercise preview chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: FH.Spacing.sm) {
                    ForEach(workout.exercises.prefix(4)) { exercise in
                        Button {
                            FHHaptics.selection()
                            selectedExercise = exercise
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: exercise.sfSymbol)
                                    .font(.system(size: 10))
                                Text(exercise.name)
                                    .font(.system(size: 11, weight: .medium))
                            }
                            .foregroundStyle(FH.Colors.textMuted)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(FH.Colors.surface2)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    if workout.exercises.count > 4 {
                        Text("+\(workout.exercises.count - 4) more")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(FH.Colors.textSubtle)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(FH.Colors.surface2)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
    }

    private func menuButton(for workout: Workout) -> some View {
        Menu {
            Button {
                FHHaptics.selection()
                selectedWorkout = workout
            } label: {
                Label("View Details", systemImage: "eye")
            }

            Button {
                FHHaptics.selection()
                workoutToEdit = workout
            } label: {
                Label("Edit", systemImage: "pencil")
            }

            Button {
                FHHaptics.selection()
                let duplicated = Workout(
                    name: "\(workout.name) Copy",
                    category: workout.category,
                    estimatedMinutes: workout.estimatedMinutes,
                    exercises: workout.exercises
                )
                workouts.append(duplicated)
            } label: {
                Label("Duplicate", systemImage: "doc.on.doc")
            }

            Divider()

            Button(role: .destructive) {
                FHHaptics.medium()
                workouts.removeAll(where: { $0.id == workout.id })
            } label: {
                Label("Delete", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(FH.Colors.textMuted)
                .frame(width: 36, height: 36)
                .background(FH.Colors.surface2)
                .clipShape(Circle())
        }
    }

    private func statPill(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(text)
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(FH.Colors.textMuted)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(FH.Colors.surface2)
        .clipShape(Capsule())
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            showNewWorkout = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(FH.Colors.primaryInk)
                .frame(width: 56, height: 56)
                .background(FH.Colors.primary)
                .clipShape(Circle())
                .shadow(color: FH.Colors.primary.opacity(0.3), radius: 12, x: 0, y: 6)
        }
    }
}

// MARK: - New Workout Sheet

struct NewWorkoutSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var category = ""
    @State private var duration = "45"
    @State private var selectedExercises: [Exercise] = []
    @State private var showExercisePicker = false

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: FH.Spacing.xl) {
                    sheetHandle

                    Text("New Workout")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: FH.Spacing.lg) {
                        inputField(label: "Workout Name", text: $name, placeholder: "e.g. Upper Body Power")
                        inputField(label: "Category", text: $category, placeholder: "e.g. Push / Pull / Legs")
                        inputField(label: "Duration (min)", text: $duration, placeholder: "45")

                        // Selected exercises
                        VStack(alignment: .leading, spacing: FH.Spacing.md) {
                            HStack {
                                Text("EXERCISES")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(FH.Colors.textSubtle)
                                    .tracking(1.2)
                                Spacer()
                                Text("\(selectedExercises.count)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(FH.Colors.textMuted)
                            }

                            if selectedExercises.isEmpty {
                                Button {
                                    showExercisePicker = true
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add exercises from library")
                                    }
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(FH.Colors.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, FH.Spacing.lg)
                                    .background(FH.Colors.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: FH.Radius.lg)
                                            .stroke(FH.Colors.primary.opacity(0.3), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            } else {
                                VStack(spacing: FH.Spacing.sm) {
                                    ForEach(selectedExercises) { exercise in
                                        HStack {
                                            Image(systemName: exercise.sfSymbol)
                                                .font(.system(size: 14))
                                                .foregroundStyle(FH.Colors.textMuted)
                                            Text(exercise.name)
                                                .font(.system(size: 14))
                                                .foregroundStyle(FH.Colors.text)
                                            Spacer()
                                            Text("\(exercise.targetSets)×\(exercise.targetReps)")
                                                .font(.system(size: 12, design: .monospaced))
                                                .foregroundStyle(FH.Colors.textMuted)
                                        }
                                        .padding(FH.Spacing.md)
                                        .background(FH.Colors.surface2)
                                        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                                    }

                                    Button {
                                        showExercisePicker = true
                                    } label: {
                                        HStack {
                                            Image(systemName: "plus")
                                            Text("Add more")
                                        }
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(FH.Colors.primary)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.top, FH.Spacing.xs)
                                }
                            }
                        }
                    }

                    Button {
                        dismiss()
                    } label: {
                        Text("Create Workout")
                    }
                    .buttonStyle(FHPrimaryButtonStyle())
                    .padding(.top, FH.Spacing.md)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, FH.Spacing.base)
            }
        }
        .sheet(isPresented: $showExercisePicker) {
            ExercisePickerSheet(selectedExercises: $selectedExercises)
        }
    }

    private var sheetHandle: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.white.opacity(0.2))
            .frame(width: 38, height: 5)
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
            .padding(.bottom, FH.Spacing.md)
    }

    private func inputField(label: String, text: Binding<String>, placeholder: String) -> some View {
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
        }
    }
}

// MARK: - Exercise Picker Sheet

struct ExercisePickerSheet: View {
    @Binding var selectedExercises: [Exercise]
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var previewExercise: Exercise? = nil

    var filteredExercises: [Exercise] {
        if searchText.isEmpty { return SampleData.exerciseLibrary }
        return SampleData.exerciseLibrary.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("Add Exercises")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(FH.Colors.primary)
                    }
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.top, FH.Spacing.lg)
                .padding(.bottom, FH.Spacing.md)

                HStack(spacing: FH.Spacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundStyle(FH.Colors.textSubtle)
                    TextField("Search", text: $searchText)
                        .font(.system(size: 15))
                        .foregroundStyle(FH.Colors.text)
                }
                .padding(.horizontal, FH.Spacing.md)
                .padding(.vertical, FH.Spacing.sm)
                .background(FH.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.pill))
                .overlay(
                    RoundedRectangle(cornerRadius: FH.Radius.pill)
                        .stroke(FH.Colors.border, lineWidth: 1)
                )
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.md)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: FH.Spacing.sm) {
                        ForEach(filteredExercises) { exercise in
                            let isSelected = selectedExercises.contains(where: { $0.id == exercise.id })
                            HStack(spacing: FH.Spacing.md) {
                                Button {
                                    if isSelected {
                                        selectedExercises.removeAll(where: { $0.id == exercise.id })
                                    } else {
                                        selectedExercises.append(exercise)
                                    }
                                } label: {
                                    HStack(spacing: FH.Spacing.md) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: FH.Radius.md)
                                                .fill(isSelected ? FH.Colors.primary.opacity(0.15) : FH.Colors.surface2)
                                                .frame(width: 40, height: 40)
                                            Image(systemName: exercise.sfSymbol)
                                                .font(.system(size: 16))
                                                .foregroundStyle(isSelected ? FH.Colors.primary : FH.Colors.textMuted)
                                        }

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(exercise.name)
                                                .font(.system(size: 15, weight: isSelected ? .semibold : .medium))
                                                .foregroundStyle(isSelected ? FH.Colors.primary : FH.Colors.text)
                                            Text("\(exercise.targetSets) sets · \(exercise.targetReps) reps")
                                                .font(.system(size: 12))
                                                .foregroundStyle(FH.Colors.textMuted)
                                        }

                                        Spacer()

                                        if isSelected {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 22))
                                                .foregroundStyle(FH.Colors.primary)
                                        } else {
                                            Circle()
                                                .stroke(FH.Colors.border, lineWidth: 1.5)
                                                .frame(width: 22, height: 22)
                                        }
                                    }
                                    .padding(FH.Spacing.md)
                                    .background(isSelected ? FH.Colors.primary.opacity(0.05) : FH.Colors.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: FH.Radius.lg)
                                            .stroke(isSelected ? FH.Colors.primary.opacity(0.35) : FH.Colors.border, lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)

                                // Info button
                                Button {
                                    FHHaptics.selection()
                                    previewExercise = exercise
                                } label: {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 16))
                                        .foregroundStyle(FH.Colors.textSubtle)
                                        .frame(width: 36, height: 44)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .sheet(item: $previewExercise) { exercise in
                ExerciseDetailView(exercise: exercise, showClientData: false)
            }
        }
    }
}

#Preview {
    WorkoutListView()
        .preferredColorScheme(.dark)
}
