import SwiftUI

struct AddMeasurementSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var date = Date()
    @State private var weight = ""
    @State private var chest = ""
    @State private var waist = ""
    @State private var hips = ""
    @State private var leftArm = ""
    @State private var rightArm = ""
    @State private var leftThigh = ""
    @State private var rightThigh = ""

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
            Text("WEIGHT")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

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
        // In a real app: persist to backend or local store
        dismiss()
    }
}

#Preview {
    AddMeasurementSheet()
        .preferredColorScheme(.dark)
}
