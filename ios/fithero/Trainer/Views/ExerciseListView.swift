import SwiftUI

struct ExerciseListView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showNewExercise = false

    let categories = ["All", "Push", "Pull", "Legs", "Core", "Mobility", "Cardio"]

    var filteredExercises: [Exercise] {
        var result = SampleData.exerciseLibrary
        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: FH.Spacing.xl) {
                    searchBar
                    categoryPills
                    exerciseList
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xxxl)
            }

            addButton
                .padding(.trailing, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xl)
        }
        .sheet(isPresented: $showNewExercise) {
            NewExerciseSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Search

    private var searchBar: some View {
        HStack(spacing: FH.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundStyle(FH.Colors.textSubtle)
            TextField("Search exercises", text: $searchText)
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

    // MARK: - Categories

    private var categoryPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: FH.Spacing.sm) {
                ForEach(categories, id: \.self) { cat in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedCategory = cat
                        }
                    } label: {
                        Text(cat)
                            .font(.system(size: 13, weight: selectedCategory == cat ? .semibold : .medium))
                            .foregroundStyle(selectedCategory == cat ? FH.Colors.primaryInk : FH.Colors.textMuted)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedCategory == cat ? FH.Colors.primary : FH.Colors.surface2)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(selectedCategory == cat ? FH.Colors.primary : FH.Colors.border, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - List

    private var exerciseList: some View {
        VStack(spacing: FH.Spacing.sm) {
            ForEach(filteredExercises) { exercise in
                exerciseRow(exercise)
            }

            if filteredExercises.isEmpty {
                VStack(spacing: FH.Spacing.md) {
                    Image(systemName: "dumbbell")
                        .font(.system(size: 32))
                        .foregroundStyle(FH.Colors.textSubtle)
                    Text("No exercises found")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(FH.Colors.textMuted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, FH.Spacing.xxl)
            }
        }
    }

    private func exerciseRow(_ exercise: Exercise) -> some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(categoryColor(exercise.category).opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: exercise.sfSymbol)
                    .font(.system(size: 20))
                    .foregroundStyle(categoryColor(exercise.category))
                    .symbolRenderingMode(.hierarchical)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)

                HStack(spacing: FH.Spacing.sm) {
                    Text(exercise.category)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(categoryColor(exercise.category))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(categoryColor(exercise.category).opacity(0.12))
                        .clipShape(Capsule())

                    Text("\(exercise.targetSets) sets · \(exercise.targetReps) reps")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(FH.Colors.textMuted)
                        .monospacedDigit()
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
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            showNewExercise = true
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

    // MARK: - Helpers

    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "Push": FH.Colors.accent
        case "Pull": FH.Colors.primary
        case "Legs": FH.Colors.warning
        case "Core": FH.Colors.success
        case "Mobility": FH.Colors.textMuted
        case "Cardio": FH.Colors.danger
        default: FH.Colors.textMuted
        }
    }
}

// MARK: - New Exercise Sheet

struct NewExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var category = "Push"
    @State private var sets = "3"
    @State private var reps = "10"
    @State private var rest = "60"
    @State private var notes = ""

    let categories = ["Push", "Pull", "Legs", "Core", "Mobility", "Cardio"]

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: FH.Spacing.xl) {
                    sheetHandle

                    Text("New Exercise")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: FH.Spacing.lg) {
                        inputField(label: "Name", text: $name, placeholder: "e.g. Incline Dumbbell Press")

                        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                            Text("CATEGORY")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(FH.Colors.textSubtle)
                                .tracking(1.2)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: FH.Spacing.sm) {
                                    ForEach(categories, id: \.self) { cat in
                                        Button {
                                            category = cat
                                        } label: {
                                            Text(cat)
                                                .font(.system(size: 13, weight: category == cat ? .semibold : .medium))
                                                .foregroundStyle(category == cat ? FH.Colors.primaryInk : FH.Colors.textMuted)
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 8)
                                                .background(category == cat ? FH.Colors.primary : FH.Colors.surface2)
                                                .clipShape(Capsule())
                                                .overlay(
                                                    Capsule()
                                                        .stroke(category == cat ? FH.Colors.primary : FH.Colors.border, lineWidth: 1)
                                                )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        HStack(spacing: FH.Spacing.md) {
                            inputField(label: "Sets", text: $sets, placeholder: "3")
                            inputField(label: "Reps", text: $reps, placeholder: "10")
                            inputField(label: "Rest (s)", text: $rest, placeholder: "60")
                        }

                        inputField(label: "Notes", text: $notes, placeholder: "Form cues, setup tips...")
                    }

                    Button {
                        dismiss()
                    } label: {
                        Text("Create Exercise")
                    }
                    .buttonStyle(FHPrimaryButtonStyle())
                    .padding(.top, FH.Spacing.md)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, FH.Spacing.base)
            }
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

#Preview {
    ExerciseListView()
        .preferredColorScheme(.dark)
}
