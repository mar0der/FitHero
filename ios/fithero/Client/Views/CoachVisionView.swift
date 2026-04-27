import SwiftUI

struct CoachVisionView: View {
    @State private var selectedFocus = DemoFocus.mobility
    @State private var recoveryMode = true
    @State private var macroPlan = MacroPlan.performance
    @State private var confidenceLevel = 0.86

    private let dayPlan = DemoDayPlan.example
    private let wins = DemoWin.sample

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: FH.Spacing.xl) {
                readinessCard
                focusSelector
                adaptivePlanCard
                nutritionCard
                coachMessageCard
                momentumSection
            }
            .padding(.horizontal, FH.Spacing.base)
            .padding(.top, FH.Spacing.lg)
            .padding(.bottom, FH.Spacing.xxxl)
        }
        .background(FH.Colors.bg)
    }

    private var readinessCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack {
                Text("TODAY'S READINESS")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                Spacer()

                Toggle("", isOn: $recoveryMode.animation(.easeInOut(duration: 0.25)))
                    .labelsHidden()
                    .tint(FH.Colors.primary)
            }

            HStack(alignment: .center, spacing: FH.Spacing.lg) {
                ZStack {
                    Circle()
                        .stroke(FH.Colors.surface2, lineWidth: 10)
                        .frame(width: 110, height: 110)

                    Circle()
                        .trim(from: 0, to: recoveryMode ? 0.82 : 0.63)
                        .stroke(
                            AngularGradient(
                                colors: [FH.Colors.primary, FH.Colors.accent, FH.Colors.primary],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .frame(width: 110, height: 110)
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 2) {
                        Text(recoveryMode ? "82" : "63")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(FH.Colors.text)
                        Text(recoveryMode ? "green light" : "scaled down")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(recoveryMode ? FH.Colors.success : FH.Colors.warning)
                    }
                }

                VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                    readinessRow(icon: "bed.double.fill", title: "Sleep", value: recoveryMode ? "7h 48m" : "5h 56m")
                    readinessRow(icon: "heart.fill", title: "Recovery", value: recoveryMode ? "HRV stable" : "Elevated strain")
                    readinessRow(icon: "figure.walk.motion", title: "Load", value: recoveryMode ? "Ready to push" : "Shift to technique")
                }
            }

            Text(recoveryMode ? "Recovery mode is on: the plan keeps intensity high and advances your push session." : "Recovery dipped, so the plan automatically swaps heavy volume for crisp technique work and mobility.")
                .font(.system(size: 14))
                .foregroundStyle(FH.Colors.textMuted)
                .lineSpacing(3)
        }
        .fhCard()
    }

    private func readinessRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: FH.Spacing.sm) {
            Image(systemName: icon)
                .frame(width: 18)
                .foregroundStyle(FH.Colors.primary)

            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(FH.Colors.textMuted)

            Spacer()

            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(FH.Colors.text)
        }
    }

    private var focusSelector: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("FOCUS TRACK")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            HStack(spacing: FH.Spacing.sm) {
                ForEach(DemoFocus.allCases) { focus in
                    Button {
                        selectedFocus = focus
                        confidenceLevel = focus.confidence
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(focus.title)
                                .font(.system(size: 14, weight: .semibold))
                            Text(focus.subtitle)
                                .font(.system(size: 11))
                        }
                        .foregroundStyle(selectedFocus == focus ? FH.Colors.primaryInk : FH.Colors.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(selectedFocus == focus ? FH.Colors.primary : FH.Colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .fhCard()
    }

    private var adaptivePlanCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ADAPTIVE DAY PLAN")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(FH.Colors.textSubtle)
                        .tracking(1.2)

                    Text(selectedFocus.headline(recoveryMode: recoveryMode))
                        .font(.system(size: 21, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                }

                Spacer()

                Text(recoveryMode ? "Live" : "Adjusted")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(recoveryMode ? FH.Colors.primaryInk : FH.Colors.bg)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(recoveryMode ? FH.Colors.primary : FH.Colors.warning)
                    .clipShape(Capsule())
            }

            VStack(spacing: FH.Spacing.md) {
                ForEach(dayPlan.steps(for: selectedFocus, recoveryMode: recoveryMode)) { step in
                    HStack(alignment: .top, spacing: FH.Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(step.tint.opacity(0.16))
                                .frame(width: 38, height: 38)
                            Image(systemName: step.icon)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(step.tint)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(step.title)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(FH.Colors.text)
                                Spacer()
                                Text(step.duration)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(FH.Colors.textSubtle)
                            }

                            Text(step.detail)
                                .font(.system(size: 13))
                                .foregroundStyle(FH.Colors.textMuted)
                                .lineSpacing(2)
                        }
                    }
                    .padding(.bottom, 2)
                }
            }
        }
        .fhCard()
    }

    private var nutritionCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack {
                Text("FUELING LAYER")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
                Spacer()
                Picker("Macro Plan", selection: $macroPlan) {
                    ForEach(MacroPlan.allCases) { plan in
                        Text(plan.title).tag(plan)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 220)
            }

            HStack(spacing: FH.Spacing.base) {
                macroStat(label: "Protein", value: macroPlan.protein, tone: FH.Colors.primary)
                macroStat(label: "Carbs", value: macroPlan.carbs, tone: FH.Colors.accent)
                macroStat(label: "Hydration", value: macroPlan.hydration, tone: FH.Colors.success)
            }

            Text(macroPlan.description(recoveryMode: recoveryMode))
                .font(.system(size: 13))
                .foregroundStyle(FH.Colors.textMuted)
                .lineSpacing(2)
        }
        .fhCard()
    }

    private func macroStat(label: String, value: String, tone: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(FH.Colors.textSubtle)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(FH.Colors.text)
                .monospacedDigit()
            Capsule()
                .fill(tone)
                .frame(height: 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var coachMessageCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack {
                ZStack {
                    Circle()
                        .fill(FH.Colors.accent.opacity(0.18))
                        .frame(width: 42, height: 42)
                    Text("M")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(FH.Colors.accent)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Coach Maya")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(FH.Colors.text)
                    Text("Suggested update")
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.textSubtle)
                }

                Spacer()

                Image(systemName: "waveform.path.ecg")
                    .foregroundStyle(FH.Colors.primary)
            }

            Text(selectedFocus.coachPrompt(recoveryMode: recoveryMode))
                .font(.system(size: 15))
                .foregroundStyle(FH.Colors.text)
                .lineSpacing(3)

            HStack(spacing: FH.Spacing.sm) {
                Button("Apply Plan") { }
                    .buttonStyle(FHPrimaryButtonStyle())

                Button("Message Coach") { }
                    .buttonStyle(FHSecondaryButtonStyle())
            }
        }
        .fhCard()
    }

    private var momentumSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("MOMENTUM THIS WEEK")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            ForEach(wins) { win in
                HStack(spacing: FH.Spacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: FH.Radius.md)
                            .fill(win.tint.opacity(0.14))
                            .frame(width: 44, height: 44)
                        Image(systemName: win.icon)
                            .foregroundStyle(win.tint)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(win.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(FH.Colors.text)
                        Text(win.detail)
                            .font(.system(size: 13))
                            .foregroundStyle(FH.Colors.textMuted)
                    }

                    Spacer()
                }
                .padding(FH.Spacing.base)
                .background(FH.Colors.surface.opacity(0.96))
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: FH.Radius.lg)
                        .stroke(FH.Colors.border, lineWidth: 1)
                )
            }
        }
    }
}

private enum DemoFocus: String, CaseIterable, Identifiable {
    case strength
    case mobility
    case fatLoss

    var id: String { rawValue }

    var title: String {
        switch self {
        case .strength: return "Strength"
        case .mobility: return "Mobility"
        case .fatLoss: return "Fat Loss"
        }
    }

    var subtitle: String {
        switch self {
        case .strength: return "Progressive overload"
        case .mobility: return "Move better today"
        case .fatLoss: return "Keep the deficit smart"
        }
    }

    var confidence: Double {
        switch self {
        case .strength: return 0.91
        case .mobility: return 0.86
        case .fatLoss: return 0.88
        }
    }

    func headline(recoveryMode: Bool) -> String {
        switch (self, recoveryMode) {
        case (.strength, true): return "Push session with a heavier top set"
        case (.strength, false): return "Strength intent preserved, volume trimmed"
        case (.mobility, true): return "Reset hips and shoulders before tonight's lift"
        case (.mobility, false): return "Mobility-first day with low fatigue output"
        case (.fatLoss, true): return "High-burn circuit plus steady step target"
        case (.fatLoss, false): return "Shorter conditioning block with appetite control"
        }
    }

    func coachPrompt(recoveryMode: Bool) -> String {
        switch (self, recoveryMode) {
        case (.strength, true):
            return "You’re recovered enough to chase a confident top set today. We’ll keep the back-off work clean and log bar speed after each main lift."
        case (.strength, false):
            return "You still show up, we just protect the downside. I’d like you to keep the main lift technical, stop two reps shy of grind, and bank a quality session."
        case (.mobility, true):
            return "Your body is ready, so this mobility block is there to unlock better positions before training, not slow you down. Treat it like a performance primer."
        case (.mobility, false):
            return "Recovery signals are a bit flat, so this plan shifts from intensity to restoration. If you finish feeling smoother than you started, we won today."
        case (.fatLoss, true):
            return "Energy looks good. We can drive output without draining tomorrow’s session by pairing short intervals with a higher-protein meal cadence."
        case (.fatLoss, false):
            return "Today is about keeping momentum while avoiding rebound hunger. Short conditioning, smart hydration, and tighter meal timing will do more than forcing volume."
        }
    }
}

private enum MacroPlan: String, CaseIterable, Identifiable {
    case performance
    case balanced
    case lean

    var id: String { rawValue }

    var title: String {
        switch self {
        case .performance: return "Perform"
        case .balanced: return "Balance"
        case .lean: return "Lean"
        }
    }

    var protein: String {
        switch self {
        case .performance: return "165g"
        case .balanced: return "155g"
        case .lean: return "170g"
        }
    }

    var carbs: String {
        switch self {
        case .performance: return "240g"
        case .balanced: return "190g"
        case .lean: return "145g"
        }
    }

    var hydration: String {
        switch self {
        case .performance: return "3.4L"
        case .balanced: return "3.0L"
        case .lean: return "3.2L"
        }
    }

    func description(recoveryMode: Bool) -> String {
        switch (self, recoveryMode) {
        case (.performance, true):
            return "Higher carbohydrate timing around training supports output, replenishment, and better session quality without changing overall structure."
        case (.performance, false):
            return "Carbs stay front-loaded earlier in the day while total intensity comes down, so recovery improves without losing consistency."
        case (.balanced, true):
            return "A steady middle path for clients who want visible progress, solid energy, and fewer nutrition decisions."
        case (.balanced, false):
            return "Balanced fueling keeps appetite steadier on lower-readiness days and reduces the urge to over-correct later."
        case (.lean, true):
            return "A sharper body-composition day: protein stays high, carbs are more deliberate, and hydration keeps perceived effort in check."
        case (.lean, false):
            return "Lower-readiness fat-loss days favor satiety and adherence. Keep the meals simple, protein-led, and predictable."
        }
    }
}

private struct DemoDayPlan {
    let strengthReady: [DemoPlanStep]
    let strengthRecovery: [DemoPlanStep]
    let mobilityReady: [DemoPlanStep]
    let mobilityRecovery: [DemoPlanStep]
    let fatLossReady: [DemoPlanStep]
    let fatLossRecovery: [DemoPlanStep]

    static let example = DemoDayPlan(
        strengthReady: [
            DemoPlanStep(title: "Warm-up ramp", detail: "Breathing reset, shoulder prep, and two barbell ramp sets before the main push block.", duration: "8 min", icon: "figure.strengthtraining.traditional", tint: FH.Colors.primary),
            DemoPlanStep(title: "Top-set bench press", detail: "Build to one confident heavy set, then 3 controlled back-off sets with 90-second rest.", duration: "18 min", icon: "bolt.fill", tint: FH.Colors.warning),
            DemoPlanStep(title: "Accessory density", detail: "Row, incline press, and tricep finisher arranged as a quality circuit.", duration: "14 min", icon: "square.stack.3d.up.fill", tint: FH.Colors.accent)
        ],
        strengthRecovery: [
            DemoPlanStep(title: "Positioning warm-up", detail: "Longer prep to open the thoracic spine and reduce front-rack stiffness before loading.", duration: "10 min", icon: "figure.flexibility", tint: FH.Colors.accent),
            DemoPlanStep(title: "Technique bench wave", detail: "Submaximal sets at smoother tempo with stricter rest to preserve pattern quality.", duration: "16 min", icon: "dial.low.fill", tint: FH.Colors.warning),
            DemoPlanStep(title: "Flush finisher", detail: "Light incline dumbbells, band pull-aparts, and an easy cooldown walk.", duration: "12 min", icon: "heart.text.square.fill", tint: FH.Colors.success)
        ],
        mobilityReady: [
            DemoPlanStep(title: "Mobility primer", detail: "Ankle, hip, and T-spine sequence to improve range before your evening strength session.", duration: "9 min", icon: "figure.cooldown", tint: FH.Colors.primary),
            DemoPlanStep(title: "Core stability block", detail: "Dead bugs, side planks, and loaded carries to turn mobility into usable control.", duration: "12 min", icon: "figure.core.training", tint: FH.Colors.accent),
            DemoPlanStep(title: "Lift prep finish", detail: "Two activation supersets so you enter the gym feeling switched on instead of loose.", duration: "8 min", icon: "flame.fill", tint: FH.Colors.warning)
        ],
        mobilityRecovery: [
            DemoPlanStep(title: "Nervous system downshift", detail: "Slow breathing and long exhale work to bring tension down before movement.", duration: "6 min", icon: "lungs.fill", tint: FH.Colors.success),
            DemoPlanStep(title: "Joint-friendly flow", detail: "Low-impact mobility sequence for hips, shoulders, and trunk rotation with no fatigue spike.", duration: "14 min", icon: "figure.mind.and.body", tint: FH.Colors.primary),
            DemoPlanStep(title: "Walk and reset", detail: "Short walk target plus hydration cue to keep recovery moving the rest of the day.", duration: "20 min", icon: "figure.walk", tint: FH.Colors.accent)
        ],
        fatLossReady: [
            DemoPlanStep(title: "Step-up circuit", detail: "Short lower-body circuit with crisp pace to elevate heart rate without trashing form.", duration: "15 min", icon: "figure.highintensity.intervaltraining", tint: FH.Colors.warning),
            DemoPlanStep(title: "Conditioning ladder", detail: "Bike intervals paired with bodyweight moves to drive output in a controlled window.", duration: "16 min", icon: "chart.line.uptrend.xyaxis", tint: FH.Colors.primary),
            DemoPlanStep(title: "Meal timing cue", detail: "Post-session protein plus fiber-forward lunch to reduce late-day hunger swings.", duration: "All day", icon: "fork.knife", tint: FH.Colors.accent)
        ],
        fatLossRecovery: [
            DemoPlanStep(title: "Low-impact cardio", detail: "Zone 2 incline walk to keep expenditure up while preserving recovery and appetite control.", duration: "25 min", icon: "shoeprints.fill", tint: FH.Colors.primary),
            DemoPlanStep(title: "Movement snacks", detail: "Three short mobility breaks spread through the day to keep energy from dipping.", duration: "3 x 4 min", icon: "clock.badge.checkmark.fill", tint: FH.Colors.accent),
            DemoPlanStep(title: "Satiety-first meals", detail: "Protein, hydration, and high-volume foods become the lever instead of extra training stress.", duration: "All day", icon: "takeoutbag.and.cup.and.straw.fill", tint: FH.Colors.success)
        ]
    )

    func steps(for focus: DemoFocus, recoveryMode: Bool) -> [DemoPlanStep] {
        switch (focus, recoveryMode) {
        case (.strength, true): return strengthReady
        case (.strength, false): return strengthRecovery
        case (.mobility, true): return mobilityReady
        case (.mobility, false): return mobilityRecovery
        case (.fatLoss, true): return fatLossReady
        case (.fatLoss, false): return fatLossRecovery
        }
    }
}

private struct DemoPlanStep: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let duration: String
    let icon: String
    let tint: Color
}

private struct DemoWin: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let icon: String
    let tint: Color

    static let sample: [DemoWin] = [
        DemoWin(title: "Bench bar speed improved", detail: "Your last two pressing sessions showed cleaner lockout with less perceived effort.", icon: "bolt.heart.fill", tint: FH.Colors.primary),
        DemoWin(title: "Nutrition adherence hit 92%", detail: "Meal timing stayed consistent across work days, which is exactly the pattern we want.", icon: "checkmark.seal.fill", tint: FH.Colors.success),
        DemoWin(title: "Coach workload got lighter", detail: "This kind of screen can package recommendations, nudges, and plan changes without back-and-forth friction.", icon: "sparkles.rectangle.stack.fill", tint: FH.Colors.accent)
    ]
}

#Preview {
    CoachVisionView()
        .preferredColorScheme(.dark)
}
