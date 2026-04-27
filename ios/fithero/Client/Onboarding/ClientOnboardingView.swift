import SwiftUI

struct ClientOnboardingView: View {
    var onComplete: () -> Void = {}

    @State private var step: OnboardingStep = .basics
    @State private var data = OnboardingData()
    @State private var direction: SlideDirection = .forward
    @Environment(\.dismiss) private var dismiss

    private let totalSteps = 5 // excluding complete

    init(onComplete: @escaping () -> Void = {}) {
        self.onComplete = onComplete
    }

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                if step != .complete {
                    progressHeader
                }

                contentStack
                    .frame(maxHeight: .infinity)

                if step != .complete {
                    bottomBar
                }
            }
        }
    }

    // MARK: - Progress Header

    private var progressHeader: some View {
        VStack(spacing: FH.Spacing.md) {
            HStack(spacing: FH.Spacing.sm) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(index < step.progressIndex ? FH.Colors.primary : FH.Colors.surface2)
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                        .animation(.easeInOut(duration: 0.3), value: step)
                }
            }

            HStack {
                Text(step.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(FH.Colors.textMuted)
                Spacer()
                Text("Step \(step.progressIndex) of \(totalSteps)")
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.textSubtle)
            }
        }
        .padding(.horizontal, FH.Spacing.base)
        .padding(.top, FH.Spacing.lg)
    }

    // MARK: - Content

    private var contentStack: some View {
        Group {
            switch step {
            case .basics: basicsStep
            case .goals: goalsStep
            case .injuries: injuriesStep
            case .experience: experienceStep
            case .measurements: measurementsStep
            case .complete: completeStep
            }
        }
        .padding(.horizontal, FH.Spacing.base)
    }

    // MARK: - Bottom Bar

    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider().background(FH.Colors.border)

            HStack(spacing: FH.Spacing.md) {
                if step.canGoBack {
                    Button {
                        direction = .backward
                        withAnimation(.easeInOut(duration: 0.25)) {
                            step = step.previous
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(FH.Colors.text)
                            .frame(width: 52, height: 52)
                            .background(FH.Colors.surface2)
                            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                            .overlay(
                                RoundedRectangle(cornerRadius: FH.Radius.md)
                                    .stroke(FH.Colors.border, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    direction = .forward
                    withAnimation(.easeInOut(duration: 0.25)) {
                        step = step.next
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(step == .measurements ? "Finish" : "Continue")
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .buttonStyle(FHPrimaryButtonStyle())

                if step.canSkip {
                    Button {
                        direction = .forward
                        withAnimation(.easeInOut(duration: 0.25)) {
                            step = step.next
                        }
                    } label: {
                        Text("Skip")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(FH.Colors.textMuted)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, FH.Spacing.base)
            .padding(.vertical, FH.Spacing.md)
            .padding(.bottom, FH.Spacing.xxxl)
            .background(FH.Colors.bg)
        }
    }

    // MARK: - Step 1: Basics

    private var basicsStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: FH.Spacing.xl) {
                VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                    Text("Let's start with the basics")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                    Text("This helps your coach personalize your program.")
                        .font(.system(size: 15))
                        .foregroundStyle(FH.Colors.textMuted)
                }

                VStack(spacing: FH.Spacing.lg) {
                    inputField(label: "Full name", text: $data.name, placeholder: "Alex Johnson")
                    inputField(label: "Age", text: $data.age, placeholder: "34", keyboard: .numberPad)

                    HStack(spacing: FH.Spacing.md) {
                        inputField(label: "Height (cm)", text: $data.height, placeholder: "180", keyboard: .numberPad)
                        inputField(label: "Weight (kg)", text: $data.weight, placeholder: "80", keyboard: .numberPad)
                    }
                }

                Spacer(minLength: 40)
            }
            .padding(.top, FH.Spacing.xl)
        }
    }

    // MARK: - Step 2: Goals

    private var goalsStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: FH.Spacing.xl) {
                VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                    Text("What's your main goal?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                    Text("Pick the one that matters most right now.")
                        .font(.system(size: 15))
                        .foregroundStyle(FH.Colors.textMuted)
                }

                VStack(spacing: FH.Spacing.md) {
                    GoalCard(
                        icon: "flame.fill",
                        title: "Lose weight",
                        subtitle: "Burn fat, improve cardio",
                        isSelected: data.goal == "Lose weight",
                        action: { data.goal = "Lose weight" }
                    )
                    GoalCard(
                        icon: "dumbbell.fill",
                        title: "Build muscle",
                        subtitle: "Gain strength and size",
                        isSelected: data.goal == "Build muscle",
                        action: { data.goal = "Build muscle" }
                    )
                    GoalCard(
                        icon: "heart.text.square.fill",
                        title: "Rehab / PT",
                        subtitle: "Recover from injury safely",
                        isSelected: data.goal == "Rehab",
                        action: { data.goal = "Rehab" }
                    )
                    GoalCard(
                        icon: "figure.walk",
                        title: "General health",
                        subtitle: "Feel better, move more",
                        isSelected: data.goal == "General health",
                        action: { data.goal = "General health" }
                    )
                }

                Spacer(minLength: 40)
            }
            .padding(.top, FH.Spacing.xl)
        }
    }

    // MARK: - Step 3: Injuries

    private var injuriesStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: FH.Spacing.xl) {
                VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                    Text("Any injuries or concerns?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                    Text("Your coach needs to know to keep you safe.")
                        .font(.system(size: 15))
                        .foregroundStyle(FH.Colors.textMuted)
                }

                VStack(spacing: FH.Spacing.sm) {
                    InjuryCheckbox(label: "Lower back", isOn: bindingForInjury("Lower back"))
                    InjuryCheckbox(label: "Knees", isOn: bindingForInjury("Knees"))
                    InjuryCheckbox(label: "Shoulders", isOn: bindingForInjury("Shoulders"))
                    InjuryCheckbox(label: "Neck", isOn: bindingForInjury("Neck"))
                    InjuryCheckbox(label: "Hips", isOn: bindingForInjury("Hips"))
                    InjuryCheckbox(label: "None", isOn: bindingForInjury("None"))
                }

                VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                    Text("NOTES")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(FH.Colors.textSubtle)
                        .tracking(1.2)

                    ZStack(alignment: .topLeading) {
                        if data.injuryNotes.isEmpty {
                            Text("Describe any pain, surgeries, or conditions...")
                                .font(.system(size: 15))
                                .foregroundStyle(FH.Colors.textSubtle)
                                .padding(.top, 10)
                                .padding(.leading, 4)
                                .allowsHitTesting(false)
                        }
                        TextEditor(text: $data.injuryNotes)
                            .font(.system(size: 15))
                            .foregroundStyle(FH.Colors.text)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 100)
                    }
                    .padding(FH.Spacing.md)
                    .background(FH.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                    .overlay(
                        RoundedRectangle(cornerRadius: FH.Radius.lg)
                            .stroke(FH.Colors.border, lineWidth: 1)
                    )
                }

                Spacer(minLength: 40)
            }
            .padding(.top, FH.Spacing.xl)
        }
    }

    private func bindingForInjury(_ injury: String) -> Binding<Bool> {
        Binding(
            get: { data.injuries.contains(injury) },
            set: { isOn in
                if isOn {
                    if injury == "None" {
                        data.injuries = ["None"]
                    } else {
                        data.injuries.removeAll(where: { $0 == "None" })
                        data.injuries.append(injury)
                    }
                } else {
                    data.injuries.removeAll(where: { $0 == injury })
                }
            }
        )
    }

    // MARK: - Step 4: Experience

    private var experienceStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: FH.Spacing.xl) {
                VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                    Text("What's your training experience?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                    Text("Be honest — this shapes where you start.")
                        .font(.system(size: 15))
                        .foregroundStyle(FH.Colors.textMuted)
                }

                VStack(spacing: FH.Spacing.md) {
                    ExperienceCard(
                        level: "Beginner",
                        description: "New to structured training. Learning form and building habits.",
                        isSelected: data.experience == "Beginner",
                        action: { data.experience = "Beginner" }
                    )
                    ExperienceCard(
                        level: "Intermediate",
                        description: "6+ months of consistent training. Comfortable with most movements.",
                        isSelected: data.experience == "Intermediate",
                        action: { data.experience = "Intermediate" }
                    )
                    ExperienceCard(
                        level: "Advanced",
                        description: "2+ years of serious training. Chasing PRs and fine-tuning.",
                        isSelected: data.experience == "Advanced",
                        action: { data.experience = "Advanced" }
                    )
                }

                Spacer(minLength: 40)
            }
            .padding(.top, FH.Spacing.xl)
        }
    }

    // MARK: - Step 5: Measurements

    private var measurementsStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: FH.Spacing.xl) {
                VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                    Text("Baseline measurements")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                    Text("Optional — helps track progress visually.")
                        .font(.system(size: 15))
                        .foregroundStyle(FH.Colors.textMuted)
                }

                // Photo upload placeholder
                Button {
                    data.hasPhoto.toggle()
                } label: {
                    HStack(spacing: FH.Spacing.md) {
                        ZStack {
                            RoundedRectangle(cornerRadius: FH.Radius.lg)
                                .fill(data.hasPhoto ? FH.Colors.primary.opacity(0.15) : FH.Colors.surface2)
                                .frame(width: 64, height: 64)
                            Image(systemName: data.hasPhoto ? "checkmark.circle.fill" : "camera.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(data.hasPhoto ? FH.Colors.primary : FH.Colors.textMuted)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(data.hasPhoto ? "Photo added" : "Add progress photo")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(data.hasPhoto ? FH.Colors.primary : FH.Colors.text)
                            Text("Front-facing, good lighting")
                                .font(.system(size: 13))
                                .foregroundStyle(FH.Colors.textMuted)
                        }

                        Spacer()
                    }
                    .padding(FH.Spacing.md)
                    .background(FH.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                    .overlay(
                        RoundedRectangle(cornerRadius: FH.Radius.lg)
                            .stroke(data.hasPhoto ? FH.Colors.primary.opacity(0.35) : FH.Colors.border, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)

                VStack(spacing: FH.Spacing.lg) {
                    HStack(spacing: FH.Spacing.md) {
                        measurementField(label: "Chest", text: $data.measurements.chest)
                        measurementField(label: "Waist", text: $data.measurements.waist)
                    }
                    HStack(spacing: FH.Spacing.md) {
                        measurementField(label: "Hips", text: $data.measurements.hips)
                        measurementField(label: "Left arm", text: $data.measurements.leftArm)
                    }
                    HStack(spacing: FH.Spacing.md) {
                        measurementField(label: "Right arm", text: $data.measurements.rightArm)
                        measurementField(label: "Left thigh", text: $data.measurements.leftThigh)
                    }
                    measurementField(label: "Right thigh", text: $data.measurements.rightThigh)
                }

                Spacer(minLength: 40)
            }
                .padding(.top, FH.Spacing.xl)
        }
    }

    // MARK: - Step 6: Complete

    private var completeStep: some View {
        VStack(spacing: FH.Spacing.xxl) {
            Spacer()

            VStack(spacing: FH.Spacing.xl) {
                ZStack {
                    Circle()
                        .fill(FH.Colors.primary.opacity(0.15))
                        .frame(width: 120, height: 120)
                    Circle()
                        .stroke(FH.Colors.primary.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                    Image(systemName: "checkmark")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(FH.Colors.primary)
                }

                VStack(spacing: FH.Spacing.sm) {
                    Text("You're all set!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                    Text("Your coach will build your personalized program.")
                        .font(.system(size: 15))
                        .foregroundStyle(FH.Colors.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, FH.Spacing.xl)
                }
            }

            Spacer()

            Button {
                onComplete()
            } label: {
                Text("Go to Dashboard")
            }
            .buttonStyle(FHPrimaryButtonStyle())
            .padding(.bottom, FH.Spacing.xxxl)
        }
    }

    // MARK: - Helpers

    private func inputField(label: String, text: Binding<String>, placeholder: String, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            Text(label.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)
            TextField(placeholder, text: text)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(FH.Colors.text)
                .keyboardType(keyboard)
                .padding(.horizontal, FH.Spacing.md)
                .padding(.vertical, FH.Spacing.md)
                .background(FH.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: FH.Radius.md)
                        .stroke(FH.Colors.border, lineWidth: 1)
                )
        }
    }

    private func measurementField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            Text(label.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)
            HStack {
                TextField("0.0", text: text)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(FH.Colors.text)
                    .keyboardType(.decimalPad)
                Text("cm")
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.textSubtle)
            }
            .padding(.horizontal, FH.Spacing.md)
            .padding(.vertical, FH.Spacing.md)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )
        }
    }
}

// MARK: - Step Enum

private enum OnboardingStep {
    case basics, goals, injuries, experience, measurements, complete

    var progressIndex: Int {
        switch self {
        case .basics: return 1
        case .goals: return 2
        case .injuries: return 3
        case .experience: return 4
        case .measurements: return 5
        case .complete: return 5
        }
    }

    var title: String {
        switch self {
        case .basics: return "Basics"
        case .goals: return "Goals"
        case .injuries: return "Injuries"
        case .experience: return "Experience"
        case .measurements: return "Measurements"
        case .complete: return "Complete"
        }
    }

    var next: OnboardingStep {
        switch self {
        case .basics: return .goals
        case .goals: return .injuries
        case .injuries: return .experience
        case .experience: return .measurements
        case .measurements: return .complete
        case .complete: return .complete
        }
    }

    var previous: OnboardingStep {
        switch self {
        case .basics: return .basics
        case .goals: return .basics
        case .injuries: return .goals
        case .experience: return .injuries
        case .measurements: return .experience
        case .complete: return .measurements
        }
    }

    var canGoBack: Bool {
        switch self {
        case .basics, .complete: return false
        default: return true
        }
    }

    var canSkip: Bool {
        switch self {
        case .injuries, .measurements: return true
        default: return false
        }
    }
}

private enum SlideDirection {
    case forward, backward
}

// MARK: - Subviews

private struct GoalCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: FH.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: FH.Radius.md)
                        .fill(isSelected ? FH.Colors.primary.opacity(0.15) : FH.Colors.surface2)
                        .frame(width: 52, height: 52)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(isSelected ? FH.Colors.primary : FH.Colors.textMuted)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(isSelected ? FH.Colors.primary : FH.Colors.text)
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundStyle(FH.Colors.textMuted)
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(isSelected ? FH.Colors.primary : FH.Colors.border, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Circle()
                            .fill(FH.Colors.primary)
                            .frame(width: 24, height: 24)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(FH.Colors.primaryInk)
                    }
                }
            }
            .padding(FH.Spacing.md)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .stroke(isSelected ? FH.Colors.primary.opacity(0.4) : FH.Colors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct ExperienceCard: View {
    let level: String
    let description: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                HStack {
                    Text(level)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(isSelected ? FH.Colors.primary : FH.Colors.text)
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(isSelected ? FH.Colors.primary : FH.Colors.border, lineWidth: 2)
                            .frame(width: 24, height: 24)
                        if isSelected {
                            Circle()
                                .fill(FH.Colors.primary)
                                .frame(width: 24, height: 24)
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(FH.Colors.primaryInk)
                        }
                    }
                }

                Text(description)
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
                    .lineSpacing(3)
            }
            .padding(FH.Spacing.md)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .stroke(isSelected ? FH.Colors.primary.opacity(0.4) : FH.Colors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct InjuryCheckbox: View {
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: FH.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isOn ? FH.Colors.primary : Color.clear)
                        .frame(width: 24, height: 24)
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isOn ? FH.Colors.primary : FH.Colors.border, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isOn {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(FH.Colors.primaryInk)
                    }
                }

                Text(label)
                    .font(.system(size: 16, weight: isOn ? .semibold : .medium))
                    .foregroundStyle(isOn ? FH.Colors.text : FH.Colors.textMuted)

                Spacer()
            }
            .padding(FH.Spacing.md)
            .background(isOn ? FH.Colors.primary.opacity(0.05) : FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .stroke(isOn ? FH.Colors.primary.opacity(0.3) : FH.Colors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ClientOnboardingView()
        .preferredColorScheme(.dark)
}
