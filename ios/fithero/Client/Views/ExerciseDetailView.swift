import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    var showClientData: Bool = true
    @Environment(\.dismiss) private var dismiss

    private var history: [ExerciseHistoryEntry] {
        showClientData ? SampleData.exerciseHistory(for: exercise.name) : []
    }

    private var personalRecord: PersonalRecord? {
        showClientData ? SampleData.personalRecords.first { $0.exerciseName == exercise.name } : nil
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: FH.Spacing.xl) {
                        headerCard
                        specsCard
                        if let instructions = exercise.instructions {
                            instructionsCard(instructions)
                        }
                        if showClientData, let pr = personalRecord {
                            prCard(pr)
                        }
                        if showClientData, !history.isEmpty {
                            historySection
                        }
                    }
                    .padding(FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .navigationTitle("Exercise Details")
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

    // MARK: - Header Card

    private var headerCard: some View {
        VStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .fill(FH.Colors.primary.opacity(0.12))
                    .frame(width: 72, height: 72)
                Image(systemName: exercise.sfSymbol)
                    .font(.system(size: 32))
                    .foregroundStyle(FH.Colors.primary)
                    .symbolRenderingMode(.hierarchical)
            }

            Text(exercise.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(FH.Colors.text)
                .multilineTextAlignment(.center)

            Text(exercise.category.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.primary)
                .tracking(1.2)

            // Muscle groups
            FlowLayout(spacing: FH.Spacing.sm) {
                ForEach(exercise.muscleGroups, id: \.self) { muscle in
                    Text(muscle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(FH.Colors.textMuted)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(FH.Colors.surface2)
                        .clipShape(Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(FH.Spacing.lg)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
    }

    // MARK: - Specs Card

    private var specsCard: some View {
        VStack(spacing: FH.Spacing.md) {
            specRow(icon: "square.stack.3d.up", label: "Sets", value: "\(exercise.targetSets)")
            Divider().background(FH.Colors.border)
            specRow(icon: "arrow.up.arrow.down", label: "Reps", value: exercise.targetReps)
            Divider().background(FH.Colors.border)
            specRow(icon: "timer", label: "Rest", value: "\(exercise.restSeconds)s")
            Divider().background(FH.Colors.border)
            specRow(icon: "dumbbell", label: "Equipment", value: exercise.equipment)
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
    }

    private func specRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: FH.Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.primary)
                Text(label)
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(FH.Colors.text)
        }
    }

    // MARK: - Instructions Card

    private func instructionsCard(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.accent)
                Text("HOW TO")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
            }

            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(FH.Colors.textMuted)
                .lineSpacing(3)
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
    }

    // MARK: - PR Card

    private func prCard(_ pr: PersonalRecord) -> some View {
        VStack(spacing: FH.Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.warning)
                Text("PERSONAL RECORD")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: FH.Spacing.md) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pr.value)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(FH.Colors.warning)
                    Text(pr.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: FH.Radius.md)
                        .fill(FH.Colors.warning.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: pr.sfSymbol)
                        .font(.system(size: 20))
                        .foregroundStyle(FH.Colors.warning)
                }
            }
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.warning.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.warning.opacity(0.25), lineWidth: 1))
    }

    // MARK: - History Section

    private var historySection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.primary)
                Text("RECENT HISTORY")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
            }

            VStack(spacing: FH.Spacing.sm) {
                ForEach(history) { entry in
                    historyRow(entry)
                }
            }
        }
    }

    private func historyRow(_ entry: ExerciseHistoryEntry) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.workoutName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(FH.Colors.text)
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(entry.maxWeight)) kg max")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(FH.Colors.primary)
                    Text("\(Int(entry.totalVolume)) vol")
                        .font(.system(size: 11))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
            }

            // Sets breakdown
            HStack(spacing: FH.Spacing.sm) {
                ForEach(entry.sets) { set in
                    HStack(spacing: 2) {
                        Text("\(set.setNumber)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(FH.Colors.textSubtle)
                        Text("\(Int(set.actualWeight ?? 0))×\(set.actualReps ?? 0)")
                            .font(.system(size: 10))
                            .foregroundStyle(FH.Colors.textMuted)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(FH.Colors.surface2)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
    }
}

// MARK: - Flow Layout for muscle group chips

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth, x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                self.size.width = max(self.size.width, x)
            }
            self.size.height = y + rowHeight
        }
    }
}

#Preview {
    ExerciseDetailView(exercise: SampleData.exerciseLibrary[0])
        .preferredColorScheme(.dark)
}
