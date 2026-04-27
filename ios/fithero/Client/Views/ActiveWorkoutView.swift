import SwiftUI
import Combine
import AVKit

struct ActiveWorkoutView: View {
    let workout: Workout
    let startingExerciseIndex: Int
    let onExerciseDone: (Int) -> Void   // elapsed seconds for this exercise
    let onAbandon: () -> Void           // back to read view

    @State private var sets: [SetEntry] = SampleData.benchPressSets
    @State private var isResting = false
    @State private var restTimeRemaining = 90
    @State private var weightInput = "80"
    @State private var repsInput = "10"
    @State private var elapsedSeconds = 0
    @State private var timerActive = true
    @State private var showVideo = false
    @State private var player: AVPlayer? = nil

    init(
        workout: Workout,
        startingExerciseIndex: Int = 0,
        onExerciseDone: @escaping (Int) -> Void = { _ in },
        onAbandon: @escaping () -> Void = {}
    ) {
        self.workout = workout
        self.startingExerciseIndex = startingExerciseIndex
        self.onExerciseDone = onExerciseDone
        self.onAbandon = onAbandon
    }

    private var currentExercise: Exercise { workout.exercises[startingExerciseIndex] }
    private var activeSetIndex: Int? { sets.firstIndex(where: { !$0.isCompleted }) }
    private var videoURL: URL? {
        guard currentExercise.name.lowercased().contains("bench") else { return nil }
        return Bundle.main.url(forResource: "bench_press_demo", withExtension: "mp4")
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            navBar
            Divider().background(FH.Colors.border)

            VStack(spacing: 0) {
                videoStrip
                exerciseHeader
                Spacer(minLength: 0)
                setTable
                Spacer(minLength: 0)
                bottomPanel
            }
            .padding(.horizontal, FH.Spacing.base)
            .padding(.bottom, FH.Spacing.base)
        }
        .background(FH.Colors.bg)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard timerActive else { return }
            elapsedSeconds += 1
            if isResting {
                if restTimeRemaining > 0 { restTimeRemaining -= 1 }
                else { isResting = false }
            }
        }
        .sheet(isPresented: $showVideo, onDismiss: { player?.pause() }) {
            videoSheet
        }
    }

    // MARK: - Nav bar

    private var navBar: some View {
        HStack(spacing: 0) {
            // Back to exercise list
            Button(action: onAbandon) {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 13, weight: .semibold))
                    Text("List")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(FH.Colors.textMuted)
                .frame(height: 44)
            }

            Spacer()

            // Exercise position indicator
            VStack(spacing: 5) {
                Text("Exercise \(startingExerciseIndex + 1) of \(workout.exercises.count)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
                HStack(spacing: 5) {
                    ForEach(0..<workout.exercises.count, id: \.self) { i in
                        Capsule()
                            .fill(i == startingExerciseIndex ? FH.Colors.primary : FH.Colors.surface2)
                            .frame(width: i == startingExerciseIndex ? 18 : 6, height: 6)
                    }
                }
            }

            Spacer()

            // Elapsed timer
            Text(elapsedFormatted)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundStyle(FH.Colors.textSubtle)
                .frame(height: 44)
                .monospacedDigit()
        }
        .padding(.horizontal, FH.Spacing.sm)
    }

    private var elapsedFormatted: String {
        String(format: "%d:%02d", elapsedSeconds / 60, elapsedSeconds % 60)
    }

    // MARK: - Video strip

    @ViewBuilder
    private var videoStrip: some View {
        if videoURL != nil {
            Button {
                let url = videoURL!
                player = AVPlayer(url: url)
                player?.play()
                showVideo = true
            } label: {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(FH.Colors.surface2)
                            .frame(width: 52, height: 36)
                        Image(systemName: "play.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(FH.Colors.primary)
                    }
                    Text("Watch demo")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(FH.Colors.textMuted)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
                .padding(.horizontal, FH.Spacing.md)
                .padding(.vertical, FH.Spacing.sm)
                .background(FH.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                .overlay(RoundedRectangle(cornerRadius: FH.Radius.md).stroke(FH.Colors.border, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .padding(.top, FH.Spacing.md)
        }
    }

    // MARK: - Exercise header

    private var exerciseHeader: some View {
        HStack(alignment: .center, spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(FH.Colors.primary.opacity(0.1))
                    .frame(width: 44, height: 44)
                Image(systemName: currentExercise.sfSymbol)
                    .font(.system(size: 20))
                    .foregroundStyle(FH.Colors.primary)
                    .symbolRenderingMode(.hierarchical)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(currentExercise.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                    .lineLimit(1)
                HStack(spacing: 8) {
                    chip("\(currentExercise.targetSets) sets")
                    chip("\(currentExercise.targetReps) reps")
                    chip("\(currentExercise.restSeconds)s rest")
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.top, FH.Spacing.md)
        .padding(.bottom, FH.Spacing.sm)
    }

    private func chip(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(FH.Colors.textMuted)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(FH.Colors.surface2)
            .clipShape(Capsule())
    }

    // MARK: - Set table

    private var setTable: some View {
        VStack(spacing: 0) {
            HStack {
                Text("SET").frame(width: 32, alignment: .leading)
                Text("TARGET").frame(maxWidth: .infinity, alignment: .leading)
                Text("KG").frame(width: 52, alignment: .center)
                Text("REPS").frame(width: 44, alignment: .center)
                Color.clear.frame(width: 26)
            }
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(FH.Colors.textSubtle)
            .tracking(0.8)
            .padding(.horizontal, FH.Spacing.md)
            .padding(.bottom, 6)

            VStack(spacing: 2) {
                ForEach(Array(sets.enumerated()), id: \.element.id) { index, setEntry in
                    setRow(setEntry, index: index)
                }
            }
        }
        .padding(.vertical, FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
    }

    private func setRow(_ setEntry: SetEntry, index: Int) -> some View {
        let isActive = !setEntry.isCompleted && (index == 0 || sets[index - 1].isCompleted)

        return HStack(spacing: 0) {
            Text("\(setEntry.setNumber)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(
                    setEntry.isCompleted ? FH.Colors.success
                    : isActive ? FH.Colors.primary
                    : FH.Colors.textSubtle
                )
                .frame(width: 32, alignment: .leading)

            Text("\(setEntry.targetReps) × \(Int(setEntry.targetWeight)) kg")
                .font(.system(size: 13))
                .foregroundStyle(setEntry.isCompleted ? FH.Colors.textSubtle : FH.Colors.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .strikethrough(setEntry.isCompleted, color: FH.Colors.textSubtle)

            if setEntry.isCompleted {
                Text("\(Int(setEntry.actualWeight ?? 0))")
                    .frame(width: 52, alignment: .center)
                    .foregroundStyle(FH.Colors.text)
                Text("\(setEntry.actualReps ?? 0)")
                    .frame(width: 44, alignment: .center)
                    .foregroundStyle(FH.Colors.text)
            } else {
                Text("—").frame(width: 52, alignment: .center).foregroundStyle(FH.Colors.textSubtle)
                Text("—").frame(width: 44, alignment: .center).foregroundStyle(FH.Colors.textSubtle)
            }

            ZStack {
                Circle()
                    .fill(setEntry.isCompleted ? FH.Colors.success : (isActive ? FH.Colors.primary.opacity(0.15) : FH.Colors.surface2))
                    .frame(width: 22, height: 22)
                if setEntry.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 26)
        }
        .font(.system(size: 14, weight: .semibold, design: .rounded))
        .monospacedDigit()
        .padding(.vertical, 9)
        .padding(.horizontal, FH.Spacing.md)
        .background(isActive ? FH.Colors.primary.opacity(0.05) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Bottom panel

    @ViewBuilder
    private var bottomPanel: some View {
        if isResting { restBar } else { inputsAndLog }
    }

    private var inputsAndLog: some View {
        VStack(spacing: FH.Spacing.sm) {
            if let note = currentExercise.notes {
                HStack(spacing: 6) {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 11))
                        .foregroundStyle(FH.Colors.primary.opacity(0.5))
                    Text(note)
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.textMuted)
                        .italic()
                        .lineLimit(1)
                }
                .padding(.horizontal, FH.Spacing.sm)
                .padding(.top, FH.Spacing.xs)
            }

            HStack(spacing: FH.Spacing.sm) {
                inputStepper(label: "KG", value: $weightInput, step: 2.5) { v in
                    v.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", v) : String(format: "%.1f", v)
                }
                inputStepper(label: "REPS", value: $repsInput, step: 1) { v in "\(Int(v))" }
            }

            Button { logCurrentSet() } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 16))
                    Text(activeSetIndex.map { "Log Set \($0 + 1)" } ?? "Log Set")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundStyle(FH.Colors.primaryInk)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(FH.Colors.primary)
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            }
        }
        .padding(.top, FH.Spacing.sm)
    }

    private func inputStepper(label: String, value: Binding<String>, step: Double, format: @escaping (Double) -> String) -> some View {
        HStack(spacing: 0) {
            Button {
                let v = max(0, (Double(value.wrappedValue) ?? 0) - step)
                value.wrappedValue = format(v)
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                    .frame(width: 44, height: 52)
            }
            VStack(spacing: 1) {
                Text(value.wrappedValue)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(FH.Colors.primary)
                    .monospacedDigit()
                    .frame(minWidth: 56)
                Text(label)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1)
            }
            Button {
                let v = (Double(value.wrappedValue) ?? 0) + step
                value.wrappedValue = format(v)
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                    .frame(width: 44, height: 52)
            }
        }
        .frame(maxWidth: .infinity)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.md).stroke(FH.Colors.border, lineWidth: 1))
    }

    private var restBar: some View {
        HStack(spacing: FH.Spacing.base) {
            ZStack {
                Circle().stroke(FH.Colors.surface2, lineWidth: 4)
                Circle()
                    .trim(from: 0, to: CGFloat(restTimeRemaining) / CGFloat(currentExercise.restSeconds))
                    .stroke(FH.Colors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: restTimeRemaining)
                Text("\(restTimeRemaining)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(FH.Colors.primary)
                    .monospacedDigit()
            }
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 2) {
                Text("Rest")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                Text("Next: Set \((activeSetIndex ?? 0) + 1) of \(sets.count)")
                    .font(.system(size: 12))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            Spacer()

            HStack(spacing: 6) {
                Button { restTimeRemaining = max(0, restTimeRemaining - 15) } label: {
                    Text("−15").font(.system(size: 12, weight: .semibold)).foregroundStyle(FH.Colors.textMuted)
                        .frame(width: 42, height: 36).background(FH.Colors.surface2).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Button { isResting = false } label: {
                    Text("Skip").font(.system(size: 13, weight: .bold)).foregroundStyle(FH.Colors.primaryInk)
                        .frame(width: 52, height: 36).background(FH.Colors.primary).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Button { restTimeRemaining = min(300, restTimeRemaining + 15) } label: {
                    Text("+15").font(.system(size: 12, weight: .semibold)).foregroundStyle(FH.Colors.textMuted)
                        .frame(width: 42, height: 36).background(FH.Colors.surface2).clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(.horizontal, FH.Spacing.md)
        .padding(.vertical, FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.primary.opacity(0.25), lineWidth: 1))
        .padding(.top, FH.Spacing.sm)
    }

    // MARK: - Video sheet

    private var videoSheet: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if let p = player { VideoPlayer(player: p).ignoresSafeArea() }
        }
        .presentationDetents([.fraction(0.55), .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Logic

    private func logCurrentSet() {
        guard let activeIndex = sets.firstIndex(where: { !$0.isCompleted }) else { return }
        sets[activeIndex].actualReps = Int(repsInput) ?? sets[activeIndex].targetReps
        sets[activeIndex].actualWeight = Double(weightInput) ?? sets[activeIndex].targetWeight
        sets[activeIndex].isCompleted = true

        if sets.allSatisfy(\.isCompleted) {
            // Exercise complete — tell parent
            timerActive = false
            onExerciseDone(elapsedSeconds)
        } else {
            isResting = true
            restTimeRemaining = currentExercise.restSeconds
        }
    }
}

#Preview {
    ActiveWorkoutView(workout: SampleData.todayWorkout, startingExerciseIndex: 0)
        .preferredColorScheme(.dark)
}
