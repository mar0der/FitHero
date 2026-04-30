import SwiftUI

struct AddMeasurementSheet: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("weightHistoryJSON") private var weightHistoryJSON: String = ""
    @AppStorage("measurementChest") private var measurementChest: String = ""
    @AppStorage("measurementWaist") private var measurementWaist: String = ""
    @AppStorage("measurementHips") private var measurementHips: String = ""
    @AppStorage("measurementLeftArm") private var measurementLeftArm: String = ""
    @AppStorage("measurementRightArm") private var measurementRightArm: String = ""
    @AppStorage("measurementLeftThigh") private var measurementLeftThigh: String = ""
    @AppStorage("measurementRightThigh") private var measurementRightThigh: String = ""

    @State private var date = Date()
    @State private var weight = ""
    @State private var chest = ""
    @State private var waist = ""
    @State private var hips = ""
    @State private var leftArm = ""
    @State private var rightArm = ""
    @State private var leftThigh = ""
    @State private var rightThigh = ""
    @State private var isLoadingHealth = false

    private var hasAnyValue: Bool {
        !weight.isEmpty || !chest.isEmpty || !waist.isEmpty || !hips.isEmpty
        || !leftArm.isEmpty || !rightArm.isEmpty || !leftThigh.isEmpty || !rightThigh.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: FH.Spacing.xl) {
                        dateSection
                        weightSection
                        bodySection
                    }
                    .padding(FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .navigationTitle("Add Entry")
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
                    .foregroundStyle(hasAnyValue ? FH.Colors.primary : FH.Colors.textSubtle)
                    .disabled(!hasAnyValue)
                }
            }
        }
    }

    // MARK: - Date

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            Text("DATE")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .tint(FH.Colors.primary)
                .colorScheme(.dark)
                .padding(FH.Spacing.base)
                .background(FH.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        }
    }

    // MARK: - Weight

    private var weightSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            HStack {
                Text("WEIGHT")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)
                Spacer()
                if HealthKitHelper.shared.isAvailable {
                    Button {
                        Task { await pullFromHealth() }
                    } label: {
                        HStack(spacing: 4) {
                            if isLoadingHealth {
                                ProgressView()
                                    .scaleEffect(0.7)
                            } else {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 11))
                            }
                            Text(isLoadingHealth ? "Loading..." : "Refresh from Health")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(FH.Colors.primary)
                    }
                    .disabled(isLoadingHealth)
                }
            }

            HStack(spacing: FH.Spacing.sm) {
                TextField("0.0", text: $weight)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(FH.Colors.primary)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(height: 52)
                    .background(FH.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                    .overlay(RoundedRectangle(cornerRadius: FH.Radius.md).stroke(FH.Colors.border, lineWidth: 1))

                Text("kg")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
            }
        }
    }

    private func pullFromHealth() async {
        isLoadingHealth = true
        let authorized = await HealthKitHelper.shared.requestAuth()
        if authorized {
            if let kg = await HealthKitHelper.shared.fetchMostRecentWeight() {
                await MainActor.run {
                    weight = String(format: "%.1f", kg)
                }
            }
        }
        isLoadingHealth = false
    }

    // MARK: - Body Measurements

    private var bodySection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("BODY MEASUREMENTS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            VStack(spacing: FH.Spacing.sm) {
                measurementRow(icon: "ruler", label: "Chest", value: $chest)
                measurementRow(icon: "ruler", label: "Waist", value: $waist)
                measurementRow(icon: "ruler", label: "Hips", value: $hips)
                measurementRow(icon: "ruler", label: "Left Arm", value: $leftArm)
                measurementRow(icon: "ruler", label: "Right Arm", value: $rightArm)
                measurementRow(icon: "ruler", label: "Left Thigh", value: $leftThigh)
                measurementRow(icon: "ruler", label: "Right Thigh", value: $rightThigh)
            }
        }
    }

    private func measurementRow(icon: String, label: String, value: Binding<String>) -> some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.sm)
                    .fill(FH.Colors.primary.opacity(0.1))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundStyle(FH.Colors.primary)
            }

            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(FH.Colors.text)

            Spacer()

            HStack(spacing: 4) {
                TextField("—", text: value)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(FH.Colors.primary)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                    .monospacedDigit()

                Text("cm")
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.textMuted)
            }
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
    }

    private func save() {
        FHHaptics.success()

        // Persist weight entry
        if let w = Double(weight), w > 0 {
            var history = loadWeightHistory()
            history.append(WeightEntry(date: date, weight: w))
            history.sort { $0.date < $1.date }
            saveWeightHistory(history)
        }

        // Persist measurements
        if !chest.isEmpty { measurementChest = chest }
        if !waist.isEmpty { measurementWaist = waist }
        if !hips.isEmpty { measurementHips = hips }
        if !leftArm.isEmpty { measurementLeftArm = leftArm }
        if !rightArm.isEmpty { measurementRightArm = rightArm }
        if !leftThigh.isEmpty { measurementLeftThigh = leftThigh }
        if !rightThigh.isEmpty { measurementRightThigh = rightThigh }

        dismiss()
    }

    private func loadWeightHistory() -> [WeightEntry] {
        guard !weightHistoryJSON.isEmpty,
              let data = weightHistoryJSON.data(using: .utf8),
              let entries = try? JSONDecoder().decode([PersistedWeightEntry].self, from: data) else {
            return SampleData.weightHistory
        }
        return entries.map { WeightEntry(date: Date(timeIntervalSince1970: $0.timestamp), weight: $0.weight) }
    }

    private func saveWeightHistory(_ history: [WeightEntry]) {
        let entries = history.map { PersistedWeightEntry(timestamp: $0.date.timeIntervalSince1970, weight: $0.weight) }
        if let data = try? JSONEncoder().encode(entries),
           let json = String(data: data, encoding: .utf8) {
            weightHistoryJSON = json
        }
    }
}



#Preview {
    AddMeasurementSheet()
        .preferredColorScheme(.dark)
}
