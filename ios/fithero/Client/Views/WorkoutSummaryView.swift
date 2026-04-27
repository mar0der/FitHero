import SwiftUI

struct WorkoutSummaryView: View {
    let workout: Workout
    let durationSeconds: Int
    let onDone: () -> Void

    @State private var rpe: Int = 7
    @State private var note: String = ""
    @FocusState private var noteFocused: Bool

    // Sample totals — in a real app these come from logged sets
    private var totalVolume: Int {
        workout.exercises.reduce(0) { $0 + ($1.targetSets * (Int($1.targetReps) ?? 8) * 60) }
    }
    private var formattedDuration: String {
        let m = durationSeconds / 60
        let s = durationSeconds % 60
        return String(format: "%d:%02d", m, s)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: FH.Spacing.xl) {
                    completionHero
                    statsGrid
                    rpeSection
                    noteSection
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, 120)
            }
            .scrollIndicators(.hidden)
            .background(FH.Colors.bg)

            doneBar
        }
        .background(FH.Colors.bg)
    }

    // MARK: - Completion hero

    private var completionHero: some View {
        VStack(spacing: FH.Spacing.md) {
            ZStack {
                Circle()
                    .fill(FH.Colors.primary.opacity(0.12))
                    .frame(width: 100, height: 100)
                Circle()
                    .stroke(FH.Colors.primary.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 100, height: 100)
                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(FH.Colors.primary)
            }
            .padding(.top, FH.Spacing.xl)

            VStack(spacing: FH.Spacing.xs) {
                Text("Workout Complete")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                    .tracking(-0.6)
                Text(workout.name)
                    .font(.system(size: 16))
                    .foregroundStyle(FH.Colors.textMuted)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Stats grid

    private var statsGrid: some View {
        HStack(spacing: FH.Spacing.sm) {
            summaryTile(value: formattedDuration, label: "Duration", icon: "clock.fill", accent: false)
            summaryTile(value: "\(workout.exercises.count)", label: "Exercises", icon: "dumbbell.fill", accent: false)
            summaryTile(value: "\(totalVolume / 1000)k", label: "Volume (kg)", icon: "scalemass.fill", accent: true)
        }
    }

    private func summaryTile(value: String, label: String, icon: String, accent: Bool) -> some View {
        VStack(spacing: FH.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(accent ? FH.Colors.primary : FH.Colors.textMuted)
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(accent ? FH.Colors.primary : FH.Colors.text)
                .monospacedDigit()
            Text(label.uppercased())
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(0.6)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(accent ? FH.Colors.primary.opacity(0.3) : FH.Colors.border, lineWidth: 1)
        )
    }

    // MARK: - RPE

    private var rpeSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            VStack(alignment: .leading, spacing: 3) {
                Text("HOW HARD WAS IT?")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
                Text(rpeLabel)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
            }

            // RPE pills 1–10
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: FH.Spacing.sm), count: 5), spacing: FH.Spacing.sm) {
                ForEach(1...10, id: \.self) { level in
                    Button {
                        withAnimation(.easeInOut(duration: 0.12)) { rpe = level }
                    } label: {
                        Text("\(level)")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(rpe == level ? FH.Colors.primaryInk : FH.Colors.text)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(rpe == level ? FH.Colors.primary : FH.Colors.surface2)
                            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                    }
                    .buttonStyle(.plain)
                }
            }

            Text("RPE \(rpe)/10 · \(rpeDescription)")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(0.5)
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.xl))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.xl).stroke(FH.Colors.border, lineWidth: 1))
    }

    private var rpeLabel: String {
        switch rpe {
        case 1...3: "Easy 😌"
        case 4...5: "Moderate 💪"
        case 6...7: "Hard 🔥"
        case 8...9: "Very Hard 😤"
        default: "Max Effort 🫠"
        }
    }

    private var rpeDescription: String {
        switch rpe {
        case 1...3: "Light effort, could keep going"
        case 4...5: "Challenging but comfortable"
        case 6...7: "Pushed through, solid session"
        case 8...9: "Near max, tough to finish"
        default: "Absolutely everything"
        }
    }

    // MARK: - Note

    private var noteSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            Text("SESSION NOTE")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            ZStack(alignment: .topLeading) {
                if note.isEmpty {
                    Text("How did it feel? Any PRs or issues...")
                        .font(.system(size: 14))
                        .foregroundStyle(FH.Colors.textSubtle)
                        .padding(.top, 2)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $note)
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.text)
                    .focused($noteFocused)
                    .frame(minHeight: 80)
                    .scrollContentBackground(.hidden)
            }
            .padding(FH.Spacing.md)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .stroke(noteFocused ? FH.Colors.primary.opacity(0.5) : FH.Colors.border, lineWidth: 1)
            )
        }
    }

    // MARK: - Done bar

    private var doneBar: some View {
        VStack(spacing: 0) {
            Divider().background(FH.Colors.border)
            HStack(spacing: FH.Spacing.sm) {
                Button {
                    // Send to coach — stub
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 13))
                        Text("Send to coach")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(FH.Colors.text)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(FH.Colors.surface2)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                }

                Button(action: onDone) {
                    Text("Done")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(FH.Colors.primaryInk)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(FH.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
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
    WorkoutSummaryView(workout: SampleData.todayWorkout, durationSeconds: 2645, onDone: {})
        .preferredColorScheme(.dark)
}
